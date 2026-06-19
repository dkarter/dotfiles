import type { Plugin } from '@opencode-ai/plugin';

type ToolArgs = Record<string, unknown>;

const LINEAR_SAVE_ISSUE_TOOLS = new Set(['linear_save_issue', 'mcp__linear__save_issue']);

const CREATE_ONLY_OPTIONAL_FIELDS = new Set([
  'assignee',
  'blockedBy',
  'blocks',
  'cycle',
  'delegate',
  'dueDate',
  'duplicateOf',
  'estimate',
  'labels',
  'links',
  'milestone',
  'parentId',
  'project',
  'relatedTo',
  'removeBlockedBy',
  'removeBlocks',
  'removeRelatedTo',
]);

const isLinearSaveIssueTool = (tool: string) => {
  return (
    LINEAR_SAVE_ISSUE_TOOLS.has(tool) || tool.endsWith('.linear_save_issue') || tool.endsWith('/linear_save_issue')
  );
};

const isCreate = (args: ToolArgs) => {
  return args.id === undefined || args.id === null || args.id === '';
};

const isUnsetCreateValue = (key: string, value: unknown) => {
  if (!CREATE_ONLY_OPTIONAL_FIELDS.has(key)) {
    return false;
  }

  if (value === '' || value === null || value === undefined) {
    return true;
  }

  if (Array.isArray(value) && value.length === 0) {
    return true;
  }

  // Linear estimates start at XS=1. The tool schema often fills unset estimates as 0.
  return key === 'estimate' && value === 0;
};

export const LinearMcpSanitizePlugin: Plugin = async () => {
  return {
    'tool.execute.before': async (input, output) => {
      if (!isLinearSaveIssueTool(input.tool) || !output.args || typeof output.args !== 'object') {
        return;
      }

      const args = output.args as ToolArgs;

      if (!isCreate(args)) {
        return;
      }

      delete args.id;

      for (const [key, value] of Object.entries(args)) {
        if (isUnsetCreateValue(key, value)) {
          delete args[key];
        }
      }
    },
  };
};

export default LinearMcpSanitizePlugin;
