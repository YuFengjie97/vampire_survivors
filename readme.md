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

## lesson 4
hitbox
> 攻击判定  
- collisionShape，hitbox进入hurtbox
- timer，（冷却用来重置）

hurtbox
> 受伤判定  
- collisionShape，hurtbox被hitbox进入
- timer
- cooldown（冷却），被连续攻击时，通过timer来禁用collisionShape，场景：处于火焰中。关于area_entered，只会触发一次，因为通过cooldown的timer来回禁用collisionShape，变成可以重复触发
- hitOnce（只会被攻击一次），场景：冰锥穿过多个敌人
- hitDisable（hitbox只会攻击一次），禁用hitbox的collisionShape，场景：冰球击中敌人后破碎  

layer&mask：layer是当前物体所处层，mask是要对指定层进行扫描。假设player层要对enemy层进行被进入判断，只需要将player的mask的添加enemy层，enemy的layer指定为enemy，无需再进行额外操作

## lesson 5
SpawnInfo(Resource)
> 脚本形式的资源文件，是数据的集合
![Alt text](image-2.png)  

EnemySpawner
- timer，内置计数器，计数器触发敌人生成
- 每次计数器触发，遍历spawner_info_array。如果time处于spawn_info的time_start与time_end时间段内，每隔spawn_enemy_delay就随机位置生成enemy_num个数的enemy_scene类型的敌人