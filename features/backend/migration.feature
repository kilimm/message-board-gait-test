@module:backend.migration
Feature: 旧数据迁移与备份

  @generated @layer:db @case:FP-005-001
  Scenario: 导入旧 SQLite 数据并改名备份
    Given the test database is prepared
    When [agent] 放置旧 SQLite 文件并启动服务
    Then the database table "messages" should have 1 row where "text" = "旧留言"
    And [agent] 旧 SQLite 文件被改名为 .bak 备份

  @generated @layer:db @case:FP-005-002
  Scenario: 无旧数据文件时跳过迁移
    Given the test database is prepared
    When [agent] 在没有旧数据文件时启动服务
    Then the database table "messages" should have 0 rows
    And [agent] 不生成备份文件

  @generated @layer:db @case:FP-005-003
  Scenario: 损坏的旧数据文件导入失败
    Given the test environment is ready
    When [agent] 放置损坏的 data.json 并启动服务
    Then [agent] 输出迁移失败日志且不删除原文件
