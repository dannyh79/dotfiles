import * as fs from 'node:fs'
import * as os from 'node:os'
import * as path from 'node:path'
import { spawn } from 'node:child_process'
import type { ExtensionAPI } from '@oh-my-pi/pi-coding-agent'

const PEON_SH_PATHS = [
  // ponytail: use the tool-neutral PeonPing data directory; no Claude installation or config.
  path.join(os.homedir(), '.openpeon', 'peon.sh'),
  path.join(os.homedir(), '.claude', 'hooks', 'peon-ping', 'peon.sh'),
  path.join(os.homedir(), '.openclaw', 'hooks', 'peon-ping', 'peon.sh'),
]

function findPeonSh(): string | null {
  for (const candidate of PEON_SH_PATHS) {
    try {
      if (fs.existsSync(candidate)) return candidate
    } catch {}
  }
  return null
}

function setTabTitle(title: string): void {
  process.stdout.write(`\x1b]0;${title}\x07`)
}

export default function peonPingExtension(pi: ExtensionAPI): void {
  const peonSh = findPeonSh()
  if (!peonSh) {
    console.warn('[peon-ping] peon.sh not found. Install peon-ping first.')
    return
  }

  const cwd = process.cwd()
  const projectName = path.basename(cwd) || 'omp'
  const sessionId = `omp-${Date.now()}`

  function firePeon(event: string): void {
    const payload = JSON.stringify({
      hook_event_name: event,
      notification_type: '',
      cwd,
      session_id: sessionId,
      permission_mode: '',
      source: 'omp',
    })

    try {
      const proc = spawn('bash', [peonSh], { stdio: ['pipe', 'ignore', 'ignore'] })
      proc.stdin.write(payload)
      proc.stdin.end()
      proc.unref()
    } catch {}
  }

  pi.on('session_start', async (_event, ctx) => {
    if (ctx.hasUI) setTabTitle(`${projectName}: ready`)
    firePeon('SessionStart')
  })

  pi.on('turn_start', async (_event, ctx) => {
    if (ctx.hasUI) setTabTitle(`${projectName}: working`)
    firePeon('UserPromptSubmit')
  })

  pi.on('agent_settled', async (_event, ctx) => {
    if (ctx.hasUI) setTabTitle(`● ${projectName}: done`)
    firePeon('Stop')
  })

  pi.on('tool_result', async (event, ctx) => {
    if (!event.isError) return
    if (ctx.hasUI) setTabTitle(`● ${projectName}: error`)
    firePeon('PostToolUseFailure')
  })

  pi.on('auto_compaction_start', async () => {
    firePeon('PreCompact')
  })

  pi.on('session_shutdown', async () => {
    firePeon('SessionEnd')
  })
}
