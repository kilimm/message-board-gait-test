# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 删除

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-020
  Scenario: 删除已存在留言后列表不再包含
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"待删除留言"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And I store the response field $.message.id as msgId
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      {"id":"{{var.msgId}}"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And the response body at $.total should be "0"
    Then the database table messages should have 0 row where text = "待删除留言"

  @generated @layer:api @case:MB-API-021
  Scenario: 删除不存在的留言返回未找到
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      {"id":"not-exist-id"}
      """
    Then the response status should be 404

  @generated @layer:api @case:MB-API-022
  Scenario: 删除缺少 id 返回参数错误
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      {"id":""}
      """
    Then the response status should be 400
