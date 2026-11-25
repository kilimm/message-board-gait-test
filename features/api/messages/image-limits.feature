@module:api.messages
Feature: 留言图片尺寸限制

  Background:
    Given the test environment is ready
    And I clean up the database rows in messages where text = "图片超限-001"
    And I clean up the database rows in messages where text = "图片边界-500"

  @generated @layer:api @case:FP-006-001
  Scenario: 提交宽高超过 500x500 的图片被拒绝且不写库
    When I send a POST request to "/api/messages" with encrypted JSON:
    """
    {"text":"图片超限-001","image":"{{fixture.image.base64_800x600}}"}
    """
    Then the response status should be 400
    And the response body should contain error code "IMAGE_TOO_LARGE"
    And the database table messages should have 0 rows where text = "图片超限-001"

  @generated @layer:api @case:FP-006-002
  Scenario: 提交宽高恰为 500x500 的图片可以创建成功
    When I send a POST request to "/api/messages" with encrypted JSON:
    """
    {"text":"图片边界-500","image":"{{fixture.image.base64_500x500}}"}
    """
    Then the response status should be 200
    And the database table messages should have 1 row where text = "图片边界-500"
