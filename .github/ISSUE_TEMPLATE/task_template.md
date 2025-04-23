name: Task Template
about: Default task template
title: "タスク名"
labels:
  - task
assignees:
  - your-github-username

body:
  - type: markdown
    attributes:
      value: |
        ## 説明  
        ここにタスクの概要を記入してください。

  - type: dropdown
    id: task_label
    attributes:
      label: ラベル
      description: ラベルを選んでください
      options:
        - bug
        - enhancement
        - documentation

  - type: input
    id: task_assignee
    attributes:
      label: 担当者
      description: GitHub のユーザー名を入力してください

  - type: textarea
    id: current_status
    attributes:
      label: 現在の状況
      description: 現在の進捗状況を記入してください
