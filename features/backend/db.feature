@module:backend.db
Feature: PostgreSQL 初始化与连接池

  @generated @layer:db @case:FP-004-001
  Scenario: 启动时创建消息表与索引
    Given the test database is prepared
    When [agent] 启动服务并连接数据库
    Then the database table "messages" should have 0 rows
    And [agent] public.messages 表包含 messages_created_at_idx 索引

  @generated @layer:db @case:FP-004-002
  Scenario: 连接池参数按配置生效
    Given the test environment is ready
    When [agent] 查询 pg 连接池配置
    Then [agent] 连接池最大连接数为 10 且空闲超时为 10000 毫秒

  @generated @layer:db @case:FP-004-003
  Scenario: 数据库不可用时启动失败
    Given the test environment is ready
    When [agent] 在数据库不可用时启动服务
    Then [agent] 启动失败并输出数据库连接错误日志
