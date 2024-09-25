# Vampire Survivors tutorial follow

## lesson 0
[asserts](https://github.com/brannotaylor/SurvivorsClone_Base)

## lesson 1
### background  
sprite2D设置资源文件。region设置大小，texture-filter设置过滤样式，texture-repeat设置重复
### player  
动画，AnimateSprite2D设置角色动画，自动播放，循环播放
![Alt text](image.png)  
移动逻辑，_input检测输入设置属性，_physics_process对velocity修改，move_and_slide()运动，normlize()向量归一化，delta帧时间对齐运动