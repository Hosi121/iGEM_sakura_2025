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
        ## 説明
        このタスクが何を目的としているか記入してください。

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
      description: GitHubユーザー名をカンマ区切りで記入してください

  - type: textarea
    id: current_status
    attributes:
      label: 現在の状況
      description: 現在の進捗状況を簡単に記入してください
