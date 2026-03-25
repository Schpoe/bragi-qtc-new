import React, { useState } from "react";
import { base44 } from "@/api/base44Client";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Label } from "@/components/ui/label";
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Progress } from "@/components/ui/progress";
import { Loader2, RefreshCw, CheckCircle2, AlertCircle } from "lucide-react";

export default function JiraImportDialog({ open, onOpenChange, teams: existingTeams = [] }) {
  const [jql, setJql] = useState('project = PROD');
  const [syncResult, setSyncResult] = useState(null);
  const [error, setError] = useState(null);
  const [importing, setImporting] = useState(false);
  const [fetching, setFetching] = useState(false);
  const queryClient = useQueryClient();

  const { data: existingWorkAreas = [] } = useQuery({
    queryKey: ['workAreas'],
    queryFn: () => base44.entities.WorkArea.list(),
  });

  const { data: existingWorkAreaTypes = [] } = useQuery({
    queryKey: ['workAreaTypes'],
    queryFn: () => base44.entities.WorkAreaType.list(),
  });

  const createWorkAreaType = useMutation({
    mutationFn: (typeData) => base44.entities.WorkAreaType.create(typeData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['workAreaTypes'] }),
  });

  const createWorkArea = useMutation({
    mutationFn: (workAreaData) => base44.entities.WorkArea.create(workAreaData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['workAreas'] }),
  });

  const updateWorkArea = useMutation({
    mutationFn: ({ id, workAreaData }) => base44.entities.WorkArea.update(id, workAreaData),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['workAreas'] }),
  });

  const calculateWorkAreaStats = (workAreas) => {
    if (!workAreas) return { toAdd: 0, toUpdate: 0, toSkip: 0 };
    
    let toAdd = 0, toUpdate = 0, toSkip = 0;
    
    for (const wa of workAreas) {
      const existing = existingWorkAreas.find(ewa => ewa.prod_id === wa.key);
      
      if (!existing) {
        toAdd++;
      } else {
        const hasChanged = 
          existing.name !== wa.name ||
          existing.type !== wa.type ||
          existing.leading_team_id !== wa.leadingTeam ||
          JSON.stringify(existing.supporting_team_ids || []) !== JSON.stringify(wa.supportingTeams);
        
        if (hasChanged) {
          toUpdate++;
        } else {
          toSkip++;
        }
      }
    }
    
    return { toAdd, toUpdate, toSkip };
  };

  const fetchFromJira = async () => {
    setError(null);
    setSyncResult(null);
    setFetching(true);
    
    try {
      const response = await base44.functions.invoke('jiraSync', {
        jql: jql.trim()
      });

      if (response.data.error) {
        setError(response.data.error);
        return;
      }

      setSyncResult(response.data);
    } catch (err) {
      setError(err.message || 'Failed to fetch from Jira');
    } finally {
      setFetching(false);
    }
  };

  const importData = async () => {
    if (!syncResult) return;

    setImporting(true);
    setError(null);

    try {
      const colors = ['blue', 'green', 'purple', 'orange', 'pink', 'teal'];
      let stats = {
        typesCreated: 0,
        workAreasCreated: 0,
        workAreasUpdated: 0,
        workAreasSkipped: 0,
        errors: []
      };

      // Map teams to existing teams only
      const teamMap = {};
      for (const teamName of syncResult.teams) {
        const existing = existingTeams.find(t => t.name.toLowerCase() === teamName.toLowerCase());
        if (existing) {
          teamMap[teamName] = existing.id;
        }
      }

      // Import work item types
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

      // Import work items
      for (const workArea of syncResult.workAreas) {
        try {
          const leadingTeamId = teamMap[workArea.leadingTeam] || Object.values(teamMap)[0] || existingTeams[0]?.id;

          if (!leadingTeamId) {
            stats.errors.push(`Work Item ${workArea.name}: No team available`);
            continue;
          }

          const supportingTeamIds = workArea.supportingTeams
            .map(t => teamMap[t])
            .filter(Boolean);

          const newData = {
            name: workArea.name,
            prod_id: workArea.key,
            type: workArea.type || '',
            leading_team_id: leadingTeamId,
            supporting_team_ids: supportingTeamIds
          };

          const existingWA = existingWorkAreas.find(wa => wa.prod_id === workArea.key);

          if (existingWA) {
            const hasChanged = 
              existingWA.name !== newData.name ||
              existingWA.type !== newData.type ||
              existingWA.leading_team_id !== newData.leading_team_id ||
              JSON.stringify(existingWA.supporting_team_ids || []) !== JSON.stringify(supportingTeamIds);

            if (hasChanged) {
              await updateWorkArea.mutateAsync({
                id: existingWA.id,
                workAreaData: newData
              });
              stats.workAreasUpdated++;
            } else {
              stats.workAreasSkipped++;
            }
          } else {
            await createWorkArea.mutateAsync({
              ...newData,
              color: colors[stats.workAreasCreated % colors.length]
            });
            stats.workAreasCreated++;
          }
        } catch (err) {
          stats.errors.push(`Work Item ${workArea.name}: ${err.message}`);
        }
      }

      setSyncResult({ ...syncResult, importStats: stats });
    } catch (err) {
      setError(err.message || 'Import failed');
    } finally {
      setImporting(false);
    }
  };

  const handleClose = () => {
    setSyncResult(null);
    setError(null);
    setJql('project = PROD');
    onOpenChange(false);
  };

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Import from Jira</DialogTitle>
          <DialogDescription>Fetch Work Items directly from Jira using JQL</DialogDescription>
        </DialogHeader>

        <div className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="jql">JQL Query</Label>
            <Textarea
              id="jql"
              placeholder='e.g., project = PROJ AND type = "Product discovery"'
              value={jql}
              onChange={(e) => setJql(e.target.value)}
              disabled={importing || fetching}
              rows={3}
              className="font-mono text-sm"
            />
            <p className="text-xs text-muted-foreground">
              Example: project = MYPROJ AND type = "Product discovery" AND status != Done
            </p>
          </div>

          <Button 
            onClick={fetchFromJira} 
            disabled={!jql.trim() || importing || fetching}
            className="w-full"
          >
            {fetching ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Fetching from Jira...
              </>
            ) : (
              <>
                <RefreshCw className="w-4 h-4 mr-2" />
                Fetch from Jira
              </>
            )}
          </Button>

          {fetching && (
            <div className="space-y-2">
              <div className="flex items-center justify-between text-sm">
                <span className="text-muted-foreground">Fetching Product Discovery issues...</span>
                <Loader2 className="w-4 h-4 animate-spin text-primary" />
              </div>
              <Progress value={50} className="h-2" />
            </div>
          )}

          {error && (
            <Alert variant="destructive">
              <AlertCircle className="w-4 h-4" />
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}

          {syncResult && !syncResult.importStats && (() => {
            const stats = calculateWorkAreaStats(syncResult.workAreas);
            return (
              <Alert>
                <CheckCircle2 className="w-4 h-4" />
                <AlertDescription>
                  <div className="space-y-2">
                    <p>Found {syncResult.totalIssues} issues, {syncResult.workAreaTypes.length} types, and {syncResult.teams.length} teams</p>
                    <div className="mt-3 pt-3 border-t border-border/50 space-y-1 text-xs">
                      <p className="font-semibold">Work Item Summary:</p>
                      <ul className="space-y-1 ml-2">
                        <li>Will be added: <span className="font-medium text-green-600">{stats.toAdd}</span></li>
                        <li>Will be updated: <span className="font-medium text-blue-600">{stats.toUpdate}</span></li>
                        <li>Will be skipped (no changes): <span className="font-medium text-amber-600">{stats.toSkip}</span></li>
                      </ul>
                    </div>
                  </div>
                </AlertDescription>
              </Alert>
            );
          })()}

          {syncResult && syncResult.importStats && (
            <Alert>
              <CheckCircle2 className="w-4 h-4" />
              <AlertDescription>
                <div className="space-y-1">
                  <p>Import completed:</p>
                  <ul className="list-disc list-inside text-sm">
                    <li>Types created: {syncResult.importStats.typesCreated}</li>
                    <li>Work Items created: {syncResult.importStats.workAreasCreated}</li>
                    <li>Work Items updated: {syncResult.importStats.workAreasUpdated}</li>
                    <li>Work Items skipped: {syncResult.importStats.workAreasSkipped}</li>
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

          {syncResult && syncResult.importStats && (
            <Button 
              onClick={handleClose}
              className="w-full"
              variant="outline"
            >
              Close
            </Button>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}