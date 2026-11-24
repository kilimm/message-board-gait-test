# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 传输加密与输入校验

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-030
  Scenario: 加密提交后响应可被同一口令解密
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-加密-030"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.message.text should be "留言-加密-030"

  @generated @layer:api @case:MB-API-031
  Scenario: 非法图片格式被拒绝
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"带图","image":"data:text/plain;base64,aGVsbG8="}
      """
    Then the response status should be 400

  @generated @layer:api @case:MB-API-032
  Scenario: 明文请求体被拒绝
    When I send a POST request to "/api/messages" with JSON:
      """
      {"text":"明文提交"}
      """
    Then the response status should be 400

  @generated @layer:api @case:MB-API-033
  Scenario: 合法 base64 图片可以创建成功
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-带图-033","image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.message.text should be "留言-带图-033"
