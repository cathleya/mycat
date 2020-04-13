
DROP TABLE IF EXISTS `order_master`;
CREATE TABLE `order_master` (
  `order_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_sn` bigint(20) unsigned NOT NULL COMMENT '订单编号 yyyymmddnnnnnnnn',
  `customer_id` int(10) unsigned NOT NULL COMMENT '下单人ID',
  `order_money` decimal(8,2) NOT NULL COMMENT '订单金额',
  `province` smallint(6) NOT NULL COMMENT '收货人所在省',
  `city` smallint(6) NOT NULL COMMENT '收货人所在市',
  `district` smallint(6) NOT NULL COMMENT '收货人所在区',
  `address` varchar(100) NOT NULL COMMENT '收货人详细地址',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单主表';

DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `order_detail_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键ID,订单详情表ID',
  `order_id` int(10) unsigned NOT NULL COMMENT '订单表ID',
  `product_name` varchar(50) NOT NULL COMMENT '商品名称',
  `product_price` decimal(8,2) NOT NULL COMMENT '购买商品单价',
  PRIMARY KEY (`order_detail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单详情表';

DROP TABLE IF EXISTS `customer_login`;
CREATE TABLE `customer_login` (
  `customer_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `login_name` varchar(20) NOT NULL COMMENT '用户登陆名',
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户登陆表';