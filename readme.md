# Vampire Survivors tutorial follow

## lesson 0
[asserts](https://github.com/brannotaylor/SurvivorsClone_Base)

## lesson 1

background  
- sprite2D设置资源文件
- region设置大小
- texture-filter设置过滤样式
- texture-repeat设置重复

player动画
- AnimateSprite2D设置角色动画，自动播放，循环播放
![Alt text](image.png)
- texture-fitler-nearest，不继承全局，使清晰  

移动逻辑
- motion mode 设置floating
- _input检测输入设置属性
- _physics_process对velocity修改 
- move_and_slide()运动
- normlize()向量归一化
- delta帧时间对齐运动

## lesson 2
player相机  
- player添加camera2D节点  
- player设置分组
- 添加collisionShape  

enemy
- 添加collisionShape
- 在onready通过分组获取player节点 
- 运动跟随，global_position是相对与根节点树的全局位置

![Alt text](image-1.png)

## lesson 3
player idle动画改为一帧，新加walk动画，两帧 
- 判断mov length，设置idle/walk
- 判断x_mov,设置flip_h设置动画反转

enemy类似