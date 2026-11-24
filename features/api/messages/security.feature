# language: zh-CN
# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 传输加密与体积上限

  前后端使用同一天派生口令进行 AES 传输加密；图片上限约 8MB。

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-030
  Scenario: 加密提交后响应可被同一口令解密
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"加密传输验证"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.ok should be "true"
    And the response body at $.message.text should be "加密传输验证"

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
