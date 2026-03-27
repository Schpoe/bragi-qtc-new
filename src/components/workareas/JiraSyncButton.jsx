import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import { RefreshCw } from "lucide-react";
import { base44 } from "@/api/base44Client";
import { toast } from "sonner";

export default function JiraSyncButton() {
  const [syncing, setSyncing] = useState(false);

  const handleSync = async () => {
    setSyncing(true);
    try {
      const response = await base44.functions.invoke('syncJiraIssues', {});
      
      if (response.data.success) {
        toast.success(`Synced ${response.data.updated} work items from Jira`);
      } else {
        toast.error('Sync failed: ' + (response.data.error || 'Unknown error'));
      }
    } catch (error) {
      toast.error('Failed to sync: ' + error.message);
    } finally {
      setSyncing(false);
    }
  };

  return (
    <Button
      variant="outline"
      onClick={handleSync}
      disabled={syncing}
      className="gap-2"
    >
      <RefreshCw className={`w-4 h-4 ${syncing ? 'animate-spin' : ''}`} />
      {syncing ? 'Syncing...' : 'Sync Jira Status'}
    </Button>
  );
}