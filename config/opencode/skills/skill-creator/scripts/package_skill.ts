#!/usr/bin/env bun
/**
 * Skill Packager - Creates a distributable .skill file of a skill folder
 *
 * Usage:
 *     bun package_skill.ts <path/to/skill-folder> [output-directory]
 *
 * Example:
 *     bun package_skill.ts skills/public/my-skill
 *     bun package_skill.ts skills/public/my-skill ./dist
 */

import * as path from 'path';
import * as fs from 'fs';
import { validateSkill } from './quick_validate';
import { spawnSync } from 'child_process';

async function packageSkill(skillPath: string, outputDir?: string): Promise<string | null> {
  /**
   * Package a skill folder into a .skill file.
   *
   * Args:
   *     skillPath: Path to the skill folder
   *     outputDir: Optional output directory for the .skill file (defaults to current directory)
   *
   * Returns:
   *     Path to the created .skill file, or null if error
   */
  const skillDir = path.resolve(skillPath);

  // Validate skill folder exists
  if (!fs.existsSync(skillDir)) {
    console.log(`❌ Error: Skill folder not found: ${skillDir}`);
    return null;
  }

  if (!fs.statSync(skillDir).isDirectory()) {
    console.log(`❌ Error: Path is not a directory: ${skillDir}`);
    return null;
  }

  // Validate SKILL.md exists
  const skillMd = path.join(skillDir, 'SKILL.md');
  if (!fs.existsSync(skillMd)) {
    console.log(`❌ Error: SKILL.md not found in ${skillDir}`);
    return null;
  }

  // Run validation before packaging
  console.log('🔍 Validating skill...');
  const validation = validateSkill(skillDir);
  if (!validation.valid) {
    console.log(`❌ Validation failed: ${validation.message}`);
    console.log('   Please fix the validation errors before packaging.');
    return null;
  }
  console.log(`✅ ${validation.message}\n`);

  // Determine output location
  const skillName = path.basename(skillDir);
  const outputPath = outputDir ? path.resolve(outputDir) : process.cwd();

  // Create output directory if it doesn't exist
  if (!fs.existsSync(outputPath)) {
    fs.mkdirSync(outputPath, { recursive: true });
  }

  const skillFilename = path.join(outputPath, `${skillName}.skill`);

  // Create the .skill file (zip format) using system zip command
  try {
    const parentDir = path.dirname(skillDir);
    const skillDirName = path.basename(skillDir);

    // List files to be added
    function listFilesRecursively(dir: string, basePath: string): string[] {
      const files: string[] = [];
      const entries = fs.readdirSync(dir, { withFileTypes: true });

      for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);
        const relativePath = path.relative(basePath, fullPath);

        // Skip unwanted files/directories
        if (entry.name === '__pycache__' || entry.name === '.DS_Store' || relativePath.includes('__pycache__')) {
          continue;
        }

        if (entry.isFile()) {
          files.push(relativePath);
          console.log(`  Added: ${relativePath}`);
        } else if (entry.isDirectory()) {
          files.push(...listFilesRecursively(fullPath, basePath));
        }
      }

      return files;
    }

    const filesToAdd = listFilesRecursively(skillDir, parentDir);

    // Use zip command to create archive
    const result = spawnSync('zip', ['-r', '-q', skillFilename, skillDirName, '-x', '*__pycache__*', '*.DS_Store'], {
      cwd: parentDir,
      stdio: 'pipe',
    });

    if (result.status !== 0) {
      const error = result.stderr?.toString() || 'Unknown error';
      throw new Error(`zip command failed: ${error}`);
    }

    console.log(`\n✅ Successfully packaged skill to: ${skillFilename}`);
    return skillFilename;
  } catch (e) {
    console.log(`❌ Error creating .skill file: ${e}`);
    return null;
  }
}

// Run as main script
if (import.meta.url === `file://${process.argv[1]}`) {
  const args = process.argv.slice(2);

  if (args.length < 1) {
    console.log('Usage: bun package_skill.ts <path/to/skill-folder> [output-directory]');
    console.log('\nExample:');
    console.log('  bun package_skill.ts skills/public/my-skill');
    console.log('  bun package_skill.ts skills/public/my-skill ./dist');
    process.exit(1);
  }

  const skillPath = args[0];
  const outputDir = args.length > 1 ? args[1] : undefined;

  console.log(`📦 Packaging skill: ${skillPath}`);
  if (outputDir) {
    console.log(`   Output directory: ${outputDir}`);
  }
  console.log();

  const result = await packageSkill(skillPath, outputDir);

  if (result) {
    process.exit(0);
  } else {
    process.exit(1);
  }
}
