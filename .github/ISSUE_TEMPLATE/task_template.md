name: Task Template
about: Default task template
title: "タスク名"
labels:
  - task
assignees: []

body:
  - type: markdown
    attributes:
      value: |
        ### このテンプレートはタスク管理用です
        必要な項目を埋めてください。

  - type: dropdown
    id: labels
    attributes:
      label: ラベル
      options:
        - bug
        - enhancement
        - documentation

  - type: input
    id: assignees
    attributes:
      label: Assignees
      description: GitHubユーザー名をカンマ区切りで入力してください

  - type: textarea
    id: current_status
    attributes:
      label: 現在の状況
      description: 現在の進捗状況などを記載してください
