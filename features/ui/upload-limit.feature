# generated-by: git-ai-test-flow
@module:unknown @layer:ui @case:AUTO-UI
Feature: 图片上传大小限制

  @module:unknown @layer:ui
  Scenario: 上传超过 500x500 的图片应被拒绝
    Given the user opens the upload page
    When the user uploads an image larger than 500x500
    Then the page shows "图片尺寸超出限制"
