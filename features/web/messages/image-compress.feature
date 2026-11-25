@module:web.messages
Feature: 前端图片压缩上传

  @generated @layer:ui @case:FP-006-003
  Scenario: 选择超大图片后压缩结果宽高均不超过 500 像素
    Given I am on the "/" page
    When [agent] 选择一张宽高为 1200x900 的本地图片并等待本地压缩完成
    Then [agent] 预览图片的宽度不超过 500 像素且高度不超过 500 像素
    And the element "发布" should be visible
