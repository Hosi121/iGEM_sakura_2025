---
name: Task Template
about: Default task template
title: "タスク名"
labels: ''
assignees: ''
body:
  - type: markdown
    attributes:
      label: 説明
  - type: dropdown
    id: labels
    attributes:
      label: ラベル
      options:
        - bug
        - enhancement
        - documentation
  - type: input
    id: assigner
    attributes:
      label: Assigner
  - type: input
    id: assignee
    attributes:
      label: Assignee
  - type: textarea
    id: current_status
    attributes:
      label: 現在の状況
