import React, { useState } from "react";
import { bragiQTC } from "@/api/bragiQTCClient";
import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { getCurrentQuarter } from "@/lib/quarter-utils";
import { useQuarters } from "@/lib/useQuarters";
import PageHeader from "../components/shared/PageHeader";
import FilterBar from "../components/shared/FilterBar";
import EmptyState from "../components/shared/EmptyState";
import { BarChart3, Users } from "lucide-react";
import { cn } from "@/lib/utils";

const teamColorMap = {
  blue: "bg-blue-500",
  indigo: "bg-indigo-500",
  purple: "bg-purple-500",
  violet: "bg-violet-500",
  fuchsia: "bg-fuchsia-500",
  pink: "bg-pink-500",
  rose: "bg-rose-500",
  red: "bg-red-500",
  orange: "bg-orange-500",
  amber: "bg-amber-500",
  yellow: "bg-yellow-500",
  lime: "bg-lime-500",
  green: "bg-emerald-500",
  teal: "bg-teal-500",
  cyan: "bg-cyan-500",
  sky: "bg-sky-500",
  slate: "bg-slate-500",
  gray: "bg-gray-500",
  zinc: "bg-zinc-500",
  stone: "bg-stone-500",
};

function UtilBar({ value, max }) {
  const pct = max > 0 ? Math.round((value / max) * 100) : 0;
  return (
    <div className="flex items-center gap-2">
      <div className="flex-1 h-2 bg-muted rounded-full overflow-hidden min-w-[60px]">
        <div
          className={cn("h-full rounded-full transition-all", pct > 100 ? "bg-destructive" : pct > 80 ? "bg-amber-500" : "bg-primary")}
          style={{ width: `${Math.min(pct, 100)}%` }}
        />
      </div>
      <span className={cn("text-xs font-semibold tabular-nums w-9 text-right", pct > 100 ? "text-destructive" : pct > 80 ? "text-amber-600" : "text-foreground")}>
        {pct}%
      </span>
    </div>
  );
}

function SprintPlanSection({ team, sprints, members, workAreas, allocations }) {
  const teamSprints = sprints.filter(s => !s.is_cross_team && s.team_id === team.id).sort((a, b) => (a.order || 0) - (b.order || 0));
  const teamMembers = members.filter(m => m.team_id === team.id);
  const memberIds = new Set(teamMembers.map(m => m.id));

  // Unique work areas across all sprints for column headers
  const allRelevantWaIds = [...new Set(teamSprints.flatMap(s => s.relevant_work_area_ids || []))];
  const teamWorkAreas = allRelevantWaIds.map(id => workAreas.find(wa => wa.id === id)).filter(Boolean);

  const getSprintWorkAreaTotal = (sprintId, workAreaId) =>
    allocations
      .filter(a => a.sprint_id === sprintId && a.work_area_id === workAreaId && memberIds.has(a.team_member_id))
      .reduce((sum, a) => sum + (a.percent || 0), 0);

  const getSprintTotal = (sprintId) => {
    const sprint = teamSprints.find(s => s.id === sprintId);
    const relevantIds = sprint?.relevant_work_area_ids;
    // If the sprint has no work items assigned, no allocations should count.
    if (!relevantIds || relevantIds.length === 0) return 0;
    return allocations
      .filter(a =>
        a.sprint_id === sprintId &&
        memberIds.has(a.team_member_id) &&
        a.work_area_id &&
        relevantIds.includes(a.work_area_id)
      )
      .reduce((sum, a) => sum + (a.percent || 0), 0);
  };

  const maxCapacityPerSprint = teamMembers.reduce((sum, m) => sum + (m.availability_percent || 100), 0);
  const totalAllocated = teamSprints.reduce((sum, s) => sum + getSprintTotal(s.id), 0);
  const maxCapacity = maxCapacityPerSprint * teamSprints.length;
  const sprintUtilPct = maxCapacity > 0 ? Math.round((totalAllocated / maxCapacity) * 100) : null;

  if (teamSprints.length === 0) {
    return (
      <div className="py-4">
        <p className="text-sm text-muted-foreground text-center py-4">No sprints in this quarter.</p>
      </div>
    );
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-2">
        <span className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">Sprint Plan</span>
        {sprintUtilPct !== null && (
          <span className={cn(
            "text-xs font-medium px-2 py-0.5 rounded-full border",
            sprintUtilPct > 100 ? "bg-destructive/10 text-destructive border-destructive/20"
            : sprintUtilPct >= 80 ? "bg-amber-50 text-amber-700 border-amber-200"
            : "bg-muted text-muted-foreground border-border"
          )}>
            Sprint utilization: {sprintUtilPct}%
          </span>
        )}
      </div>
      <div className="overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/40">
              <TableHead className="text-xs min-w-[100px]">Sprint</TableHead>
              {teamWorkAreas.map(wa => (
                <TableHead key={wa.id} className="text-center text-xs min-w-[70px]">
                  <div className="flex items-center justify-center gap-1">
                    <div className="w-2 h-2 rounded-full flex-shrink-0" style={{ backgroundColor: wa.color || "#3b82f6" }} />
                    <span className="truncate max-w-[80px]">{wa.name}</span>
                  </div>
                </TableHead>
              ))}
              <TableHead className="text-center text-xs min-w-[90px]">Utilization</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {teamSprints.map(s => {
              const total = getSprintTotal(s.id);
              return (
                <TableRow key={s.id}>
                  <TableCell className="py-2 text-xs font-medium">{s.name}</TableCell>
                  {teamWorkAreas.map(wa => {
                    const val = getSprintWorkAreaTotal(s.id, wa.id);
                    return (
                      <TableCell key={wa.id} className="text-center py-2">
                        <span className={cn("text-xs tabular-nums", val > 0 ? "font-medium" : "text-muted-foreground")}>
                          {val > 0 ? `${val}%` : "—"}
                        </span>
                      </TableCell>
                    );
                  })}
                  <TableCell className="py-2 min-w-[90px]">
                    <UtilBar value={total} max={maxCapacityPerSprint} />
                  </TableCell>
                </TableRow>
              );
            })}
            {teamWorkAreas.length === 0 && (
              <TableRow>
                <TableCell colSpan={teamSprints.length + 2} className="text-center text-xs text-muted-foreground py-4">
                  No work items assigned to sprints.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}

function QuarterlyPlanSection({ team, members, workAreas, quarterlyAllocations, workAreaSelections, quarter }) {
  const teamMembers = members.filter(m => m.team_id === team.id);
  const memberIds = new Set(teamMembers.map(m => m.id));

  // Work areas selected for this team/quarter in the quarterly plan
  const selection = workAreaSelections.find(s => s.team_id === team.id && s.quarter === quarter);
  const selectedWaIds = new Set(selection?.work_area_ids || []);

  // Also include any work area that has an actual quarterly allocation (in case selection wasn't saved)
  const allocatedWaIds = new Set(
    quarterlyAllocations
      .filter(a => memberIds.has(a.team_member_id) && a.quarter === quarter && a.work_area_id)
      .map(a => a.work_area_id)
  );

  const qaWaIds = new Set([...selectedWaIds, ...allocatedWaIds]);
  const qaWorkAreas = [...qaWaIds].map(id => workAreas.find(wa => wa.id === id)).filter(Boolean);

  const getQATotalForWA = (workAreaId) =>
    quarterlyAllocations
      .filter(a => memberIds.has(a.team_member_id) && a.quarter === quarter && a.work_area_id === workAreaId)
      .reduce((sum, a) => sum + (a.percent || 0), 0);

  const totalAllocated = qaWorkAreas.reduce((sum, wa) => sum + getQATotalForWA(wa.id), 0);
  const maxCapacity = teamMembers.reduce((sum, m) => sum + (m.availability_percent || 100), 0);
  const qtlPct = maxCapacity > 0 ? Math.round((totalAllocated / maxCapacity) * 100) : null;

  return (
    <div>
      <div className="flex items-center justify-between mb-2">
        <span className="text-xs font-semibold text-muted-foreground uppercase tracking-wide">Quarterly Plan</span>
        {qtlPct !== null && (
          <span className={cn(
            "text-xs font-medium px-2 py-0.5 rounded-full border",
            qtlPct > 100 ? "bg-destructive/10 text-destructive border-destructive/20"
            : qtlPct >= 80 ? "bg-amber-50 text-amber-700 border-amber-200"
            : "bg-muted text-muted-foreground border-border"
          )}>
            Quarterly utilization: {qtlPct}%
          </span>
        )}
      </div>
      {qaWorkAreas.length === 0 ? (
        <p className="text-sm text-muted-foreground text-center py-4">No quarterly plan entries for this quarter.</p>
      ) : (
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow className="bg-muted/40">
                <TableHead className="text-xs min-w-[100px]">Work Item</TableHead>
                <TableHead className="text-center text-xs min-w-[90px]">Total Alloc.</TableHead>
                <TableHead className="text-center text-xs min-w-[90px]">Utilization</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {qaWorkAreas.map(wa => {
                const total = getQATotalForWA(wa.id);
                return (
                  <TableRow key={wa.id}>
                    <TableCell className="py-2">
                      <div className="flex items-center gap-1.5">
                        <div className="w-2 h-2 rounded-full flex-shrink-0" style={{ backgroundColor: wa.color || "#3b82f6" }} />
                        <span className="text-xs font-medium">{wa.name}</span>
                      </div>
                    </TableCell>
                    <TableCell className="text-center py-2">
                      <span className={cn("text-xs tabular-nums", total > 0 ? "font-medium" : "text-muted-foreground")}>
                        {total > 0 ? `${total}%` : "—"}
                      </span>
                    </TableCell>
                    <TableCell className="py-2 min-w-[90px]">
                      <UtilBar value={total} max={maxCapacity} />
                    </TableCell>
                  </TableRow>
                );
              })}
            </TableBody>
          </Table>
        </div>
      )}
    </div>
  );
}

function TeamOverviewCard({ team, sprints, members, workAreas, allocations, quarterlyAllocations, workAreaSelections, quarter }) {
  const teamMembers = members.filter(m => m.team_id === team.id);

  return (
    <Card className="border-border/60">
      <CardHeader className="pb-3">
        <div className="flex items-center gap-2.5">
          <div className={`w-3 h-3 rounded-full ${teamColorMap[team.color] || "bg-primary"}`} />
          <CardTitle className="text-sm font-semibold">{team.name}</CardTitle>
          <div className="flex items-center gap-1 text-xs text-muted-foreground">
            <Users className="w-3.5 h-3.5" />
            <span>{teamMembers.length}</span>
          </div>
        </div>
      </CardHeader>
      <CardContent className="space-y-6">
        <SprintPlanSection
          team={team}
          sprints={sprints}
          members={members}
          workAreas={workAreas}
          allocations={allocations}
        />
        <div className="border-t pt-4">
          <QuarterlyPlanSection
            team={team}
            members={members}
            workAreas={workAreas}
            quarterlyAllocations={quarterlyAllocations}
            workAreaSelections={workAreaSelections}
            quarter={quarter}
          />
        </div>
      </CardContent>
    </Card>
  );
}

export default function TeamSprintOverview() {
  const [selectedQuarter, setSelectedQuarter] = useState(() => getCurrentQuarter());
  const [selectedTeam, setSelectedTeam] = useState("all");

  const { data: teams = [], isLoading: teamsLoading } = useQuery({
    queryKey: ["teams"],
    queryFn: () => bragiQTC.entities.Team.list(),
  });

  const { data: sprints = [] } = useQuery({
    queryKey: ["sprints"],
    queryFn: () => bragiQTC.entities.Sprint.list(),
  });

  const { data: members = [] } = useQuery({
    queryKey: ["teamMembers"],
    queryFn: () => bragiQTC.entities.TeamMember.list(),
  });

  const { data: workAreas = [] } = useQuery({
    queryKey: ["workAreas"],
    queryFn: () => bragiQTC.entities.WorkArea.list(),
  });

  const { data: allocations = [] } = useQuery({
    queryKey: ["allocations"],
    queryFn: () => bragiQTC.entities.Allocation.list(),
  });

  const { data: quarterlyAllocations = [] } = useQuery({
    queryKey: ["quarterlyAllocations"],
    queryFn: () => bragiQTC.entities.QuarterlyAllocation.list(),
  });

  const { data: workAreaSelections = [] } = useQuery({
    queryKey: ["workAreaSelections"],
    queryFn: () => bragiQTC.entities.QuarterlyWorkAreaSelection.list(),
  });

  const quarterSprints = sprints.filter(s => s.quarter === selectedQuarter);

  const quarters = useQuarters(sprints);

  const filteredTeams = selectedTeam === "all" ? teams : teams.filter(t => t.id === selectedTeam);

  return (
    <div>
      <PageHeader title="Team Overview" subtitle="Sprint utilization of all teams at a glance" />

      <FilterBar
        quarter={selectedQuarter}
        onQuarterChange={setSelectedQuarter}
        team={selectedTeam}
        onTeamChange={setSelectedTeam}
        teams={teams}
        quarters={quarters}
        showTeamFilter={true}
      />

      {teamsLoading ? (
        <div className="grid grid-cols-1 gap-6">
          {[1, 2, 3].map(i => <Skeleton key={i} className="h-64 rounded-xl" />)}
        </div>
      ) : teams.length === 0 ? (
        <EmptyState icon={BarChart3} title="No teams yet" description="First create teams and sprints under 'Teams' and 'Sprint Planning'." />
      ) : (
        <div className="grid grid-cols-1 gap-6">
          {filteredTeams.map(team => (
            <TeamOverviewCard
              key={team.id}
              team={team}
              sprints={quarterSprints}
              members={members}
              workAreas={workAreas}
              allocations={allocations}
              quarterlyAllocations={quarterlyAllocations}
              workAreaSelections={workAreaSelections}
              quarter={selectedQuarter}
            />
          ))}
        </div>
      )}
    </div>
  );
}