# generated-by: git-ai-test-flow
@module:api.messages @layer:db
Feature: 留言接口 - 千条上限裁剪（需串行执行）

  本用例依赖整表行数（1000 条上限），必须独占数据库：
  通过 run 选择器只选本用例、或把环境 apiConcurrency 设为 1 时执行。

  Background:
    Given the test environment is ready
    And the test database is prepared

  @generated @layer:db @case:MB-API-004
  Scenario: 表内达到一千条后再发布会裁剪最旧一条
    Given the database table messages should have 1000 row
    When I send a POST request to "/api/messages" with encrypted JSON:
      """
      {"text":"留言-trim-最新"}
      """
    Then the response status should be 200
    Then the database table messages should have 1000 row
    And the database table messages should have 1 row where text = "留言-trim-最新"
    And the database table messages should have 0 row where text = "最旧留言"
