# icoDapp
A Dapp Based on ETF Intelligence Contract

# 智能合约的数据结构和接口设计
# 数据结构
具体来说，项目需要包含的基本属性：
所有者、项目名称、资金余额、最小投资金额、最大投资金额、融资上限、投资人列表、资金支出列表；

因为资金支出条目本身所包含的属性比较多，需要单独设计其中包含的字段：
资金用途、支出金额、收款方、状态、投票记录。
# 状态流转
状态流转会包含业务流程中数据变化的各种操作和业务规则。
具体到我们的众筹智能合约，包含如下几个关键的业务流程：
创建项目、参与众筹、创建资金支出条目、给资金支出条目投票、完成资金支出。

# 技术栈
Solidity：Solidity是面向合约的高级智能合约编程语言，其设计受到了C++、Python、Javascript语言的影响，运行环境是以太坊虚拟机（EVM）,Solidity属于强类型语言，内含的类型除了常见编程语言中的标准类型，还包括address等以太坊独有的类型,Solidity源码文件通常以.sol作为扩展名;
React，负责视图层和简单的状态管理;
Next.js，负责后端请求的处理，支持服务端渲染，把 React 生态里面的各种工具帮开发者拼起来，极大的降低了 React SSR 的上手门槛，同时使用 next-routes 来实现用户友好的 URL;
Material UI，负责提供开箱即用的样式组件，相比 Semantic UI、Elemental、Element React 等更新更活跃，接触和熟悉的开发者群体更大；

# 配置管理
理论上，所有和代码逻辑无关的内容都应该放在配置文件里面，比如 DApp 中频繁使用的 Infura 地址，再比如钱包助记词，生产环境的钱包助记词需要更安全的方案去存储,Node.js 应用中做配置管理，通常使用 config.

# 服务进程管理
DApp 服务进程管理非 pm2 莫属了，不管 DApp 部署在常规虚拟机还是在 docker 容器里面，都可以使用 pm2 来管理服务进程。

# 两条命令
如果要部署智能合约 执行：npm run deploy 
如果要部署DApp 执行：npm run start

# 开启项目
克隆：https://github.com/shaneth10/icoDapp.git
安装依赖包：cnpm install 或者 npm install
安装config：npm install config
启动项目：npm run dev

