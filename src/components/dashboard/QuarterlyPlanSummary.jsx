import React, { useMemo } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrendingUp, AlertTriangle, Users } from "lucide-react";
import { cn } from "@/lib/utils";

function UtilBar({ pct }) {
  const capped = Math.min(pct, 100);
  const color =
    pct > 110 ? "bg-destructive" :
    pct > 100 ? "bg-orange-500" :
    pct >= 80 ? "bg-amber-500" :
    pct >= 50 ? "bg-primary" : "bg-muted-foreground/40";
  return (
    <div className="flex items-center gap-2 w-full">
      <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden">
        <div className={cn("h-full rounded-full transition-all", color)} style={{ width: `${capped}%` }} />
      </div>
      <span className={cn("text-xs font-semibold tabular-nums w-12 text-right",
        pct > 100 ? "text-destructive" : pct >= 80 ? "text-amber-600" : "text-muted-foreground"
      )}>
        {pct}%
      </span>
    </div>
  );
}

export default function QuarterlyPlanSummary({ teams, members, allocations, workAreas, selectedQuarter, selectedTeamId }) {
  const data = useMemo(() => {
    const relevantTeams = selectedTeamId === "all" ? teams : teams.filter(t => t.id === selectedTeamId);
    
    return relevantTeams.map((team) => {
      const teamMembers = members.filter((m) => m.team_id === team.id);
      const teamMemberIds = new Set(teamMembers.map((m) => m.id));
      
      // Quarterly allocations
      const teamQuarterlyAllocs = allocations.filter(
        (a) => a.quarter === selectedQuarter && teamMemberIds.has(a.team_member_id)
      );
      
      const teamCapacity = teamMembers.reduce((s, m) => s + (m.availability_percent || 100), 0);
      const totalAlloc = teamQuarterlyAllocs.reduce((s, a) => s + (a.percent || 0), 0);
      const utilPct = teamCapacity > 0 ? Math.round(totalAlloc / teamCapacity * 100) : 0;

      // Top work areas by allocation
      const workAreaTotals = {};
      teamQuarterlyAllocs.forEach((a) => {
        workAreaTotals[a.work_area_id] = (workAreaTotals[a.work_area_id] || 0) + (a.percent || 0);
      });
      const topWorkAreas = Object.entries(workAreaTotals)
        .sort(([, a], [, b]) => b - a)
        .slice(0, 3)
        .map(([waId, pct]) => ({
          name: workAreas.find((wa) => wa.id === waId)?.name || "Unknown",
          pct
        }));

      return { team, teamMembers, utilPct, topWorkAreas };
    });
  }, [teams, members, allocations, workAreas, selectedQuarter, selectedTeamId]);

  if (data.length === 0) {
    return (
      <div className="text-center py-8 text-muted-foreground text-sm">
        No team data available for {selectedQuarter}.
      </div>
    );
  }

  const overAllocated = data.filter(d => d.utilPct > 100).length;
  const avgUtil = data.length > 0 ? Math.round(data.reduce((s, d) => s + d.utilPct, 0) / data.length) : 0;

  return (
    <div className="space-y-4">
      {/* Summary stats */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
        <Card>
          <CardContent className="pt-4">
            <div className="flex items-start justify-between">
              <div>
                <p className="text-xs text-muted-foreground uppercase tracking-wide font-semibold">Avg Utilization</p>
                <p className={cn(
                  "text-2xl font-bold tabular-nums",
                  avgUtil > 100 ? "text-destructive" : avgUtil >= 80 ? "text-amber-600" : "text-foreground"
                )}>
                  {avgUtil}%
                </p>
              </div>
              <TrendingUp className="w-5 h-5 text-primary/40" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-4">
            <div className="flex items-start justify-between">
              <div>
                <p className="text-xs text-muted-foreground uppercase tracking-wide font-semibold">Teams</p>
                <p className="text-2xl font-bold">{data.length}</p>
              </div>
              <Users className="w-5 h-5 text-primary/40" />
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="pt-4">
            <div className="flex items-start justify-between">
              <div>
                <p className="text-xs text-muted-foreground uppercase tracking-wide font-semibold">Over-allocated</p>
                <p className={cn(
                  "text-2xl font-bold",
                  overAllocated > 0 ? "text-destructive" : "text-green-600"
                )}>
                  {overAllocated}
                </p>
              </div>
              {overAllocated > 0 && <AlertTriangle className="w-5 h-5 text-destructive/40" />}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Per-team breakdown */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {data.map(({ team, teamMembers, utilPct, topWorkAreas }) => (
          <Card key={team.id}>
            <CardContent className="pt-4">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-2 min-w-0">
                  <div className="w-2.5 h-2.5 rounded-full shrink-0" style={{ backgroundColor: team.color || "#3b82f6" }} />
                  <h4 className="font-semibold text-sm truncate">{team.name}</h4>
                  <span className="text-xs text-muted-foreground shrink-0">({teamMembers.length})</span>
                </div>
                <Badge variant={utilPct > 100 ? "destructive" : utilPct >= 80 ? "secondary" : "outline"} className="text-xs shrink-0">
                  {utilPct}%
                </Badge>
              </div>
              <UtilBar pct={utilPct} />
              
              {topWorkAreas.length > 0 && (
                <div className="mt-3 pt-3 border-t border-border/50">
                  <p className="text-xs font-semibold text-muted-foreground uppercase tracking-wide mb-2">Top Work Areas</p>
                  <div className="space-y-1.5">
                    {topWorkAreas.map(({ name, pct }) => (
                      <div key={name} className="flex items-center justify-between text-xs">
                        <span className="text-muted-foreground truncate">{name}</span>
                        <span className="font-semibold tabular-nums shrink-0 ml-2">{pct}%</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}