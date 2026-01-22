#!/usr/bin/env bun
/**
 * Quick validation script for skills - minimal version
 */

import * as path from 'path';
import * as fs from 'fs';

// Simple YAML parser for frontmatter (only need basic key-value parsing)
function parseYAML(text: string): any {
  const lines = text.split('\n');
  const result: any = {};

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;

    const colonIndex = trimmed.indexOf(':');
    if (colonIndex > 0) {
      const key = trimmed.substring(0, colonIndex).trim();
      let value = trimmed.substring(colonIndex + 1).trim();

      // Remove quotes if present
      if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }

      result[key] = value;
    }
  }

  return result;
}

interface ValidationResult {
  valid: boolean;
  message: string;
}

export function validateSkill(skillPath: string): ValidationResult {
  const skillDir = path.resolve(skillPath);

  // Check SKILL.md exists
  const skillMdPath = path.join(skillDir, 'SKILL.md');
  if (!fs.existsSync(skillMdPath)) {
    return { valid: false, message: 'SKILL.md not found' };
  }

  // Read and validate frontmatter
  const content = fs.readFileSync(skillMdPath, 'utf-8');
  if (!content.startsWith('---')) {
    return { valid: false, message: 'No YAML frontmatter found' };
  }

  // Extract frontmatter
  const match = content.match(/^---\n(.*?)\n---/s);
  if (!match) {
    return { valid: false, message: 'Invalid frontmatter format' };
  }

  const frontmatterText = match[1];

  // Parse YAML frontmatter
  let frontmatter: any;
  try {
    frontmatter = parseYAML(frontmatterText);
    if (typeof frontmatter !== 'object' || frontmatter === null || Array.isArray(frontmatter)) {
      return { valid: false, message: 'Frontmatter must be a YAML dictionary' };
    }
  } catch (e) {
    return { valid: false, message: `Invalid YAML in frontmatter: ${e}` };
  }

  // Define allowed properties
  const ALLOWED_PROPERTIES = new Set(['name', 'description', 'license', 'allowed-tools', 'metadata']);

  // Check for unexpected properties
  const unexpectedKeys = Object.keys(frontmatter).filter((key) => !ALLOWED_PROPERTIES.has(key));
  if (unexpectedKeys.length > 0) {
    return {
      valid: false,
      message: `Unexpected key(s) in SKILL.md frontmatter: ${unexpectedKeys.sort().join(', ')}. Allowed properties are: ${Array.from(ALLOWED_PROPERTIES).sort().join(', ')}`,
    };
  }

  // Check required fields
  if (!('name' in frontmatter)) {
    return { valid: false, message: "Missing 'name' in frontmatter" };
  }
  if (!('description' in frontmatter)) {
    return { valid: false, message: "Missing 'description' in frontmatter" };
  }

  // Extract name for validation
  const name = frontmatter.name || '';
  if (typeof name !== 'string') {
    return { valid: false, message: `Name must be a string, got ${typeof name}` };
  }
  const trimmedName = name.trim();
  if (trimmedName) {
    // Check naming convention (hyphen-case: lowercase with hyphens)
    if (!/^[a-z0-9-]+$/.test(trimmedName)) {
      return {
        valid: false,
        message: `Name '${trimmedName}' should be hyphen-case (lowercase letters, digits, and hyphens only)`,
      };
    }
    if (trimmedName.startsWith('-') || trimmedName.endsWith('-') || trimmedName.includes('--')) {
      return {
        valid: false,
        message: `Name '${trimmedName}' cannot start/end with hyphen or contain consecutive hyphens`,
      };
    }
    // Check name length (max 64 characters per spec)
    if (trimmedName.length > 64) {
      return {
        valid: false,
        message: `Name is too long (${trimmedName.length} characters). Maximum is 64 characters.`,
      };
    }
  }

  // Extract and validate description
  const description = frontmatter.description || '';
  if (typeof description !== 'string') {
    return { valid: false, message: `Description must be a string, got ${typeof description}` };
  }
  const trimmedDescription = description.trim();
  if (trimmedDescription) {
    // Check for angle brackets
    if (trimmedDescription.includes('<') || trimmedDescription.includes('>')) {
      return { valid: false, message: 'Description cannot contain angle brackets (< or >)' };
    }
    // Check description length (max 1024 characters per spec)
    if (trimmedDescription.length > 1024) {
      return {
        valid: false,
        message: `Description is too long (${trimmedDescription.length} characters). Maximum is 1024 characters.`,
      };
    }
  }

  return { valid: true, message: 'Skill is valid!' };
}

// Run as main script
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);

  if (args.length !== 1) {
    console.log('Usage: bun quick_validate.ts <skill_directory>');
    process.exit(1);
  }

  const result = validateSkill(args[0]);
  console.log(result.message);
  process.exit(result.valid ? 0 : 1);
}
