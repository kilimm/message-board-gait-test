@module:api.messages
Feature: 请求体与图片体积约束
  请求体 14mb 上限与前端 8MB 图片筛选必须明确拒绝超限输入。

  @generated @layer:api @case:FP-005-001
  Scenario: 请求体超过 14MB 上限被拒绝
    Given the test environment is ready
    And the test database is prepared
    When [agent] 构造请求体超过 14MB 的加密留言创建请求并提交到 "/api/messages"
    Then the response status should be 413
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.total should be "0"

  @generated @layer:api @case:FP-005-002
  Scenario: 正常体积的带图片留言可以创建成功
    Given the test environment is ready
    And the test database is prepared
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"带图留言","image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="}
      """
    Then the response status should be 200
    When I send a GET request to "/api/messages?limit=1"
    And I decrypt the response payload
    Then the response body at $.messages[0].text should be "带图留言"
