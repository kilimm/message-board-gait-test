# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 删除

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-020
  Scenario: 删除已存在留言后数据库不再包含
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-delete-待删-unique"}
      """
    Then the response status should be 200
    And I decrypt the response payload
    And I store the response field $.message.id as msgId
    Then the database table messages should have 1 row where text = "留言-delete-待删-unique"
    When I send a POST request to "/api/messages/delete" with encrypted JSON:
      """
      {"id":"{{var.msgId}}"}
      """
    Then the response status should be 200
    Then the database table messages should have 0 row where text = "留言-delete-待删-unique"

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
