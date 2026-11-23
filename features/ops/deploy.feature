@module:ops.deploy
Feature: PM2 部署与启停脚本

  @generated @layer:e2e @case:FP-009-001
  Scenario: 以生产模式单实例启动服务
    Given the test environment is ready
    When [agent] 执行 start.sh start
    Then [agent] pm2 以 production 模式单实例运行 server.js

  @generated @layer:e2e @case:FP-009-002
  Scenario: 进程已存在时不重复启动
    Given the test environment is ready
    When [agent] 在 pm2 中已有留言板进程时执行 start.sh start
    Then [agent] 输出已运行提示且不重复启动

  @generated @layer:e2e @case:FP-009-003
  Scenario: pm2 未安装时输出错误
    Given the test environment is ready
    When [agent] 在未安装 pm2 的环境执行 start.sh start
    Then [agent] 输出 pm2 缺失错误
