#!/usr/bin/env bash
set -euo pipefail
set -exuo pipefail

# ----------------------------------------
# 前提：このスクリプトはリポジトリのルートで実行
# ----------------------------------------

# ----------------------------------------
# マッピング
# ----------------------------------------
declare -A STATUS_MAP=(
  ["進行中"]="in-progress"
  ["未着手"]="todo"
  ["完了"]="done"
)
declare -A PRIORITY_MAP=(
  ["高"]="high"
  ["中"]="medium"
  ["低"]="low"
)
declare -A SECTOR_MAP=(
  ["sponsor"]="sponsor"
  ["クラファン"]="crowdfunding"
  ["口座開設"]="account-opening"
  ["wiki"]="wiki"
  ["PI"]="pi"
  ["iGEM"]="igem"
)

# タスク定義：タイトル｜進行状況｜相手属性｜優先度｜セクター
TASKS=$(cat tasks.txt)

# ----------------------------------------
# ラベル作成関数
ensure_label(){
  local name="$1" color="$2" desc="${3:-}"
  # Check if label exists
  if ! gh label list --limit 200 | grep -q "^${name}[[:space:]]"; then
    # Create label using GitHub API
    curl -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      https://api.github.com/repos/Hosi121/iGEM_sakura_2025/labels \
      -d "{ \"name\": \"$name\", \"color\": \"$color\", \"description\": \"$desc\" }" || echo "Error creating label: $name"
  fi
}

# カラー定義
COL_STATUS="0366d6"; COL_PRI="d93f0b"; COL_SECTOR="fbca04"; COL_COUNTER="0e8a16"

# ----------------------------------------
# Issue 作成ループ
IFS=$'\n'
for item in $TASKS; do
  IFS='|' read -r title jp_status jp_counter jp_pri jp_sector <<< "$item"
  status=${STATUS_MAP[$jp_status]:-$jp_status}
  if [ -z "$jp_pri" ]; then
    priority="medium"
  else
    priority=${PRIORITY_MAP[$jp_pri]:-}
  fi
  if [ -z "$jp_sector" ]; then
    sector="none"
  else
    sector=${SECTOR_MAP[$jp_sector]:-}
  fi

  # 相手属性ラベル決定
  counters=()
  [[ "$jp_counter" == *企業*   ]] && counters+=("company")
  [[ "$jp_counter" == *個人*   ]] && counters+=("individual")
  [[ "$jp_counter" == *クラファン* ]] && counters+=("crowdfunding")
  [[ "$jp_counter" == *口座開設*  ]] && counters+=("account-opening")
  [[ "$jp_counter" == *PI宛*   ]] && counters+=("pi")
  [[ "$jp_counter" == *iGEM宛* ]] && counters+=("igem")

  # ラベルをすべて作成（なければ）
  ensure_label "$status"  "$COL_STATUS"   "ステータス: $jp_status"
  [[ -n "$priority" ]] && ensure_label "$priority" "$COL_PRI"    "優先度: $jp_pri"
  [[ -n "$sector"   ]] && ensure_label "$sector"   "$COL_SECTOR" "セクター: $jp_sector"
  for c in "${counters[@]}"; do
    ensure_label "$c" "$COL_COUNTER" "相手属性: $c"
  done

  # Issue 本文
  body=$(
    cat <<EOS
**Proceeding**: $jp_status
**Counterpart**: $jp_counter
**Priority**: ${jp_pri:-(none)}
**Sector**: ${jp_sector:-(none)}
EOS
  )

  # Issue 作成
  labels=("--label" "$status")
  [[ -n "$priority" ]] && labels+=("--label" "$priority")
  [[ -n "$sector"   ]] && labels+=("--label" "$sector")
  for c in "${counters[@]}"; do
    labels+=("--label" "$c")
  done

  gh issue create \
    --title "$title" \
    --body "$body" \
    "${labels[@]}"
done
