import React, { useState } from "react";
import { base44 } from "@/api/base44Client";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Loader2, RefreshCw, CheckCircle2, AlertCircle } from "lucide-react";
import PageHeader from "@/components/shared/PageHeader";

export default function JiraSync() {
  const [projectKey, setProjectKey] = useState("");
  const [syncResult, setSyncResult] = useState(null);
  const [error, setError] = useState(null);
  const [importing, setImporting] = useState(false);
  
  const queryClient = useQueryClient();

  const { data: existingTeams = [] } = useQuery({
    queryKey: ['teams'],
    queryFn: () => base44.entities.Team.list(),
  });

  const { data: existingWorkAreaTypes = [] } = useQuery({
    queryKey: ['workAreaTypes'],
    queryFn: () => base44.entities.WorkAreaType.list(),
  });

  const createTeam = useMutation({
    mutationFn: (teamData) => base44.entities.Team.create(teamData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['teams'] }),
  });

  const createWorkAreaType = useMutation({
    mutationFn: (typeData) => base44.entities.WorkAreaType.create(typeData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['workAreaTypes'] }),
  });

  const createWorkArea = useMutation({
    mutationFn: (workAreaData) => base44.entities.WorkArea.create(workAreaData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['workAreas'] }),
  });

  const fetchFromJira = async () => {
    setError(null);
    setSyncResult(null);
    
    try {
      const response = await base44.functions.invoke('jiraSync', {
        projectKey: projectKey.trim()
      });

      if (response.data.error) {
        setError(response.data.error);
        return;
      }

      setSyncResult(response.data);
    } catch (err) {
      setError(err.message || 'Failed to fetch from Jira');
    }
  };

  const importData = async () => {
    if (!syncResult) return;

    setImporting(true);
    setError(null);

    try {
      const colors = ['blue', 'green', 'purple', 'orange', 'pink', 'teal'];
      let stats = {
        teamsCreated: 0,
        typesCreated: 0,
        workAreasCreated: 0,
        errors: []
      };

      // Import teams
      const teamMap = {};
      for (const teamName of syncResult.teams) {
        const existing = existingTeams.find(t => t.name.toLowerCase() === teamName.toLowerCase());
        if (existing) {
          teamMap[teamName] = existing.id;
        } else {
          try {
            const newTeam = await createTeam.mutateAsync({
              name: teamName,
              color: colors[stats.teamsCreated % colors.length]
            });
            teamMap[teamName] = newTeam.id;
            stats.teamsCreated++;
          } catch (err) {
            stats.errors.push(`Team ${teamName}: ${err.message}`);
          }
        }
      }

      // Import work area types
      const typeMap = {};
      for (const typeName of syncResult.workAreaTypes) {
        if (!typeName) continue;
        
        const existing = existingWorkAreaTypes.find(t => t.name.toLowerCase() === typeName.toLowerCase());
        if (existing) {
          typeMap[typeName] = existing.id;
        } else {
          try {
            await createWorkAreaType.mutateAsync({
              name: typeName,
              order: stats.typesCreated
            });
            stats.typesCreated++;
            typeMap[typeName] = typeName;
          } catch (err) {
            stats.errors.push(`Type ${typeName}: ${err.message}`);
          }
        }
      }

      // Import work areas
      for (const workArea of syncResult.workAreas) {
        try {
          // Use first team as leading team, or first existing team as fallback
          const leadingTeamId = teamMap[workArea.leadingTeam] || Object.values(teamMap)[0] || existingTeams[0]?.id;
          
          if (!leadingTeamId) {
            stats.errors.push(`Work Area ${workArea.name}: No team available`);
            continue;
          }

          const supportingTeamIds = workArea.supportingTeams
            .map(t => teamMap[t])
            .filter(Boolean);

          await createWorkArea.mutateAsync({
            name: workArea.name,
            prod_id: workArea.key,
            type: workArea.type || '',
            leading_team_id: leadingTeamId,
            supporting_team_ids: supportingTeamIds,
            color: colors[stats.workAreasCreated % colors.length]
          });
          stats.workAreasCreated++;
        } catch (err) {
          stats.errors.push(`Work Area ${workArea.name}: ${err.message}`);
        }
      }

      setSyncResult({ ...syncResult, importStats: stats });
    } catch (err) {
      setError(err.message || 'Import failed');
    } finally {
      setImporting(false);
    }
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Jira Sync"
        subtitle="Import Work Areas, Types, and Teams directly from Jira"
      />

      <Card>
        <CardHeader>
          <CardTitle>Connect to Jira</CardTitle>
          <CardDescription>
            Enter your Jira project key to fetch Product Discovery issues
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="projectKey">Project Key</Label>
            <div className="flex gap-2">
              <Input
                id="projectKey"
                placeholder="e.g., PROJ"
                value={projectKey}
                onChange={(e) => setProjectKey(e.target.value)}
                disabled={importing}
              />
              <Button 
                onClick={fetchFromJira} 
                disabled={!projectKey.trim() || importing}
              >
                <RefreshCw className="w-4 h-4 mr-2" />
                Fetch
              </Button>
            </div>
          </div>

          {error && (
            <Alert variant="destructive">
              <AlertCircle className="w-4 h-4" />
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}

          {syncResult && !syncResult.importStats && (
            <Alert>
              <CheckCircle2 className="w-4 h-4" />
              <AlertDescription>
                Found {syncResult.totalIssues} issues, {syncResult.workAreaTypes.length} types, and {syncResult.teams.length} teams
              </AlertDescription>
            </Alert>
          )}

          {syncResult && syncResult.importStats && (
            <Alert>
              <CheckCircle2 className="w-4 h-4" />
              <AlertDescription>
                <div className="space-y-1">
                  <p>Import completed:</p>
                  <ul className="list-disc list-inside text-sm">
                    <li>Teams created: {syncResult.importStats.teamsCreated}</li>
                    <li>Types created: {syncResult.importStats.typesCreated}</li>
                    <li>Work Areas created: {syncResult.importStats.workAreasCreated}</li>
                    {syncResult.importStats.errors.length > 0 && (
                      <li className="text-destructive">Errors: {syncResult.importStats.errors.length}</li>
                    )}
                  </ul>
                </div>
              </AlertDescription>
            </Alert>
          )}

          {syncResult && !syncResult.importStats && (
            <Button 
              onClick={importData} 
              disabled={importing}
              className="w-full"
            >
              {importing ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  Importing...
                </>
              ) : (
                'Import to Database'
              )}
            </Button>
          )}
        </CardContent>
      </Card>

      {syncResult && syncResult.workAreas && syncResult.workAreas.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle>Preview</CardTitle>
            <CardDescription>Issues found in Jira</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2 max-h-96 overflow-y-auto">
              {syncResult.workAreas.slice(0, 20).map((wa, idx) => (
                <div key={idx} className="flex items-center gap-2 p-2 border rounded text-sm">
                  <span className="font-mono text-muted-foreground">{wa.key}</span>
                  <span className="flex-1">{wa.name}</span>
                  {wa.type && <span className="text-xs bg-secondary px-2 py-1 rounded">{wa.type}</span>}
                </div>
              ))}
              {syncResult.workAreas.length > 20 && (
                <p className="text-sm text-muted-foreground text-center">
                  ... and {syncResult.workAreas.length - 20} more
                </p>
              )}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}