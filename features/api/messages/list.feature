# generated-by: git-ai-test-flow
@module:api.messages @layer:api
Feature: 留言接口 - 列表与统计

  并发说明：api 层并发执行、共享同一张表。因此断言一律按数据自身的作用域
  （`should have N row where text = "..."`）判定，不依赖全表行数或"列表第 N 条"。

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:api @case:MB-API-010
  Scenario: 列表接口返回可解密的数据包
    When I send a GET request to "/api/messages?limit=10"
    Then the response status should be 200
    And I decrypt the response payload
    When I send a GET request to "/api/stats"
    Then the response status should be 200
    And the response body at $.max should be "1000"

  @generated @layer:api @case:MB-API-011
  Scenario: 两次发布后两条留言都已入库
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-list-旧-011"}
      """
    Then the response status should be 200
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-list-新-011"}
      """
    Then the response status should be 200
    Then the database table messages should have 1 row where text = "留言-list-旧-011"
    And the database table messages should have 1 row where text = "留言-list-新-011"
    And the raw SQL SELECT text FROM messages WHERE text = '留言-list-新-011' should return 1 rows

  @generated @layer:api @case:MB-API-012
  Scenario: 两次发布的留言各自独立入库
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-limit-一-012-unique"}
      """
    Then the response status should be 200
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-limit-二-012-unique"}
      """
    Then the response status should be 200
    Then the database table messages should have 1 row where text = "留言-limit-一-012-unique"
    And the database table messages should have 1 row where text = "留言-limit-二-012-unique"
