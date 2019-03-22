# Homeland Integrated with YOYOW

本项目是 [DPoS Club](https://dpos.club) 源码基于[MIT](www.opensource.org/licenses/MIT) 协议的开源版本，可以通过<https://dpos.club>预览最终效果。

DPoS Club <https://dpos.club> 是一个讨论基于DPoS共识的区块链技术社区。网站基于开源的论坛系统[Homeland](https://github.com/ruby-china/homeland)搭建，并通过[YOYOW中间件](https://github.com/yoyow-org/yoyow-middleware)与YOYOW链上数据（比如账号体系）进行绑定。

现将所有代码开源，欢迎提Issue。

## 功能

DPoS Club 在Homeland的基础上，主要添加如下功能：

* 通过YOYOW中间件，添加YOYOW账号绑定
* 通过YOYOW中间件，实现通过YOYOW账号登录
* 添加资产功能，可以查看账户资产的余额以及详细变更情况
* 管理后台添加资产发放功能
* 改进新首页，支持头条文章的分类等

## Requirements
  
* Ruby >= 2.4.0  
* PostgreSQL >= 9.4  
* Redis >= 2.8  
* Memcached >= 1.4  
* Elasticsearch >= 2.0  

## Deployment

当前版本基于Homeland v3.1.2修改，部署方式可以参考Homeland的部署方式和配置，<https://gethomeland.com>。

以Ubuntu 16.04 下的安装为例

### 安装依赖

```shell
sudo apt-get install memcached postgresql libpq-dev postgresql-contrib redis-server imagemagick ghostscript
```

### 初始化

```shell
gem install bundler --conservative
bundle
# 修改配置
for file in config/*.yml.default; do cp $file "${file%.default}"; done
# 数据库环境初始化
RAILS_ENV=production bundle exec rake db:setup
# ES 环境初始化
RAILS_ENV=production bundle exec rake environment elasticsearch:import:model CLASS=Topic FORCE=y
RAILS_ENV=production bundle exec rake environment elasticsearch:import:model CLASS=Page FORCE=y
RAILS_ENV=production bundle exec rake environment elasticsearch:import:model CLASS=User FORCE=y
# Assets 压缩
RAILS_ENV=production bundle exec rails assets:precompile 
```

### 配置说明

Homeland 的具体配置 详见<https://gethomeland.com/docs/>

#### 启用YOYOW模块

如果开启YOYOW模块，需要部署YOYOW中间件[yoyow-middleware](https://github.com/yoyow-org/yoyow-middleware)，
并在配置 `config/config.yml` 中 修改 `yoyow_middleware_url` 的地址即可。

## 运行

```shell
RAILS_ENV=production bundle exec sidekiq -C config/sidekiq.yml -L /var/www/log/sidekiq.log
RAILS_ENV=production bundle exec puma -C config/puma.rb
```

## 备注

ngnix 配置示例可以参考 文件 dposclub.conf.nginx。

## 版权许可

DPoS Club 基于 [MIT](www.opensource.org/licenses/MIT) 协议开源，