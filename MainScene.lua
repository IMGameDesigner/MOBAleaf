
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    --【不变数据】
	worldW=4320;
	worldH=1500;
	screenW=1920;
	screenH=1080;
	button_move_R=190/2;
	button_move_midXmid=-700;
	button_move_midYmid=-280;
	button_attack1_midXmid=700;
	button_attack1_midYmid=-280;
	button_attack1_R=3*95/2;
	button_attack2_midXmid=840;
	button_attack2_midYmid=-420;
	button_attack2_R=95/2;
	camera_midXmid=0;
	camera_midYmid=0;
	ismoving=false;
	u_ismoving=false;
	caser=0;
	room=-1;--使timer里可调用，不可加local。但是 SP加local都能在timer里调用
	sofa=-1;
	--【服务器包含的[房间公共]数据：】
	I_midXmid=0;
	I_midYmid=0;
	I_life=100;
	I_rank=0;
	u_midXmid=0;
	u_midYmid=0;
	u_life=100;
	u_rank=0;
	car1_midXmid=-1100;
	car1_midYmid=-280;
	car1_life=100;
	car2_midXmid=1100;
	car2_midYmid=-280;
	car2_life=100;
	tower1_life=100;
	tower2_life=100;
	move_dir=0;--通过接收服务器发来的消息得到
	attack_dir=3;--通过接收服务器发来的消息得到
	u_move_dir=0;
	u_attack_dir=3;
	casert=0;
	--【服务器包含的[玩家不同]数据：】
	BY_link={};
	BY_ready={};
	BY_money={};
	BY_name={};
	BY_photo={};
    --【限制】
    display.addSpriteFrames("img/animation/animate_I.plist","img/animation/animate_I.pvr.ccz");
	display.addSpriteFrames("img/plist/car.plist","img/plist/car.png");
	display.addSpriteFrames("img/plist/life.plist","img/plist/life.png");
	display.addSpriteFrames("img/plist/shu.plist","img/plist/shu.png");
	display.addSpriteFrames("img/plist/YaoGanSmall.plist","img/plist/YaoGanSmall.png");
    math.randomseed(os.time());
    math.random(1,10000);
    --【数据】
	movepoint_x=1920/2-700;--小摇杆显示位置辅助
	movepoint_y=1080/2-280;
	client_move_dir=0;--玩家通过操作来改变（玩家输入层变量）
	direction_to_server=-1;--记上帧我方向，如我[client_move_dir]向变，就发送到服务器（玩家输入层变量）
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
	--【预加载】
	--find game 背景：
	local SP_BG_findgame=display.newSprite("img/find_game/find_game.png");
    SP_BG_findgame:align(display.CENTER, 1920/2, 1080/2);
    SP_BG_findgame:addTo(self);
    SP_BG_findgame:setVisible(false);
	
	animate=cc.MoveTo:create(1,cc.p(768/2, 1080-206/2));
    animate2=cc.EaseBounceOut:create(animate);
	local SP_BG_findgameZI=display.newSprite("img/find_game/find_game_zi.png");
    SP_BG_findgameZI:align(display.CENTER, 1920+768/2, 1080-206/2);
    SP_BG_findgameZI:addTo(self);
    SP_BG_findgameZI:setVisible(false);
	SP_BG_findgameZI:setScale(0.8);
	SP_BG_findgameZI:runAction(animate2);
-----------------------------------------------------------------------------------------------------------------------------------
	--game后背景：
	
    local SP_background3=display.newSprite("img/game/BG3.png");
    SP_background3:align(display.CENTER, screenW/2, screenH/2);
    SP_background3:addTo(self);
    SP_background3:setVisible(false);
	
	local SP_background2=display.newSprite("img/game/BG2.png");
    SP_background2:align(display.CENTER, screenW/2, screenH/2);
    SP_background2:addTo(self);
    SP_background2:setVisible(false);
	
	local SP_background1=display.newSprite("img/game/BG1.png");
    SP_background1:align(display.CENTER, screenW/2, screenH/2);
    SP_background1:addTo(self);
    SP_background1:setVisible(false);
	
	--:防御塔的攻击范围：
	local SP_tower_circle1=display.newSprite("img/game/tower_circle1.png");
    SP_tower_circle1:align(display.CENTER, screenW/2-1200, screenH/2-350);
    SP_tower_circle1:addTo(self);
    SP_tower_circle1:setVisible(false);
	SP_tower_circle1:setScale(5);
	
	local SP_tower_circle2=display.newSprite("img/game/tower_circle2.png");
    SP_tower_circle2:align(display.CENTER, screenW/2+1200, screenH/2-350);
    SP_tower_circle2:addTo(self);
    SP_tower_circle2:setVisible(false);
	SP_tower_circle2:setScale(5);
	
	--"你"叠放层次之上低
	local SP_u_up1=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_up1:align(display.CENTER, screenW/2, screenH/2);
	SP_u_up1:addTo(self);
	SP_u_up1:setVisible(false);
	SP_u_up1:setScale(3);
	
	--:"我"低叠放层次
	local SP_I_up=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_I_up:align(display.CENTER, screenW/2, screenH/2);
	SP_I_up:addTo(self);
	SP_I_up:setVisible(false);
	SP_I_up:setScale(3);
	
	--"你"叠放层次之上高
	local SP_u_up2=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_up2:align(display.CENTER, screenW/2, screenH/2);
	SP_u_up2:addTo(self);
	SP_u_up2:setVisible(false);
	SP_u_up2:setScale(3);
	
	-- 小车=小兵：(包含血条)
	local SP_car1=display.newSprite("img/game/car1.png");
    SP_car1:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid);
    SP_car1:addTo(self);
    SP_car1:setVisible(false);
	SP_car1:setScale(3);
	
	local SP_car1_life_=display.newSprite("img/game/life_.png");
    SP_car1_life_:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid+80);
    SP_car1_life_:addTo(self);
    SP_car1_life_:setVisible(false);
	
	local SP_car1_life=display.newSprite("img/game/life1.png");
    SP_car1_life:align(display.CENTER, screenW/2+car1_midXmid-130*(100-car1_life)/200, screenH/2+car1_midYmid+80);
    SP_car1_life:addTo(self);
    SP_car1_life:setVisible(false);
	SP_car1_life:setScaleX(13*car1_life/100);
	SP_car1_life:setScaleY(0.4);
	
	local SP_car2=display.newSprite("img/game/car2.png");
    SP_car2:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid);
    SP_car2:addTo(self);
    SP_car2:setVisible(false);
	SP_car2:setScale(3);
	
	local SP_car2_life_=display.newSprite("img/game/life_.png");
    SP_car2_life_:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid+80);
    SP_car2_life_:addTo(self);
    SP_car2_life_:setVisible(false);
	
	local SP_car2_life=display.newSprite("img/game/life2.png");
    SP_car2_life:align(display.CENTER, screenW/2+car2_midXmid-130*(100-car2_life)/200, screenH/2+car2_midYmid+80);
    SP_car2_life:addTo(self);
    SP_car2_life:setVisible(false);
	SP_car2_life:setScaleX(13*car2_life/100);
	SP_car2_life:setScaleY(0.4);
	
	--:防御塔：(包含血条)
	local SP_tower1=display.newSprite("img/game/tower1.png");
    SP_tower1:align(display.CENTER, screenW/2-1200, screenH/2-280);
    SP_tower1:addTo(self);
    SP_tower1:setVisible(false);
	
	local SP_tower1_life_=display.newSprite("img/game/life_.png");
    SP_tower1_life_:align(display.CENTER, screenW/2-1200, screenH/2-280+80);
    SP_tower1_life_:addTo(self);
    SP_tower1_life_:setVisible(false);
	SP_tower1_life_:setScaleY(2);
	
	local SP_tower1_life=display.newSprite("img/game/life1.png");
    SP_tower1_life:align(display.CENTER, screenW/2-1200-130*(100-tower1_life)/200, screenH/2-280+80);
    SP_tower1_life:addTo(self);
    SP_tower1_life:setVisible(false);
	SP_tower1_life:setScaleX(13*tower1_life/100);
	SP_tower1_life:setScaleY(0.8);
	
	local SP_tower2=display.newSprite("img/game/tower2.png");
    SP_tower2:align(display.CENTER, screenW/2+1200, screenH/2-280);
    SP_tower2:addTo(self);
    SP_tower2:setVisible(false);
	
	local SP_tower2_life_=display.newSprite("img/game/life_.png");
    SP_tower2_life_:align(display.CENTER, screenW/2+1200, screenH/2-280+80);
    SP_tower2_life_:addTo(self);
    SP_tower2_life_:setVisible(false);
	SP_tower2_life_:setScaleY(2);
	
	local SP_tower2_life=display.newSprite("img/game/life2.png");
    SP_tower2_life:align(display.CENTER, screenW/2+1200-130*(100-tower2_life)/200, screenH/2-280+80);
    SP_tower2_life:addTo(self);
    SP_tower2_life:setVisible(false);
	SP_tower2_life:setScaleX(13*tower2_life/100);
	SP_tower2_life:setScaleY(0.8);
	
	--"你"叠放层次之下低
	local SP_u_down1=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_down1:align(display.CENTER, screenW/2, screenH/2);
	SP_u_down1:addTo(self);
	SP_u_down1:setVisible(false);
	SP_u_down1:setScale(3);
	
	--:"我"高叠放层次
	local SP_I_down=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_I_down:align(display.CENTER, screenW/2, screenH/2);
	SP_I_down:addTo(self);
	SP_I_down:setVisible(false);
	SP_I_down:setScale(3);
	
	--"你"叠放层次之下高
	local SP_u_down2=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_down2:align(display.CENTER, screenW/2, screenH/2);
	SP_u_down2:addTo(self);
	SP_u_down2:setVisible(false);
	SP_u_down2:setScale(3);
	
	--game前背景：
	local SP_background0=display.newSprite("img/game/BG0.png");
    SP_background0:align(display.CENTER, screenW/2, screenH/2);
    SP_background0:addTo(self);
    SP_background0:setVisible(false);
	
	--:你的血条（包括等级），叠放层次仅次于我的血条
	local SP_u_life_=display.newSprite("img/game/life_.png");
    SP_u_life_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_u_life_:addTo(self);
    SP_u_life_:setVisible(false);
	SP_u_life_:setScaleY(2);
	
	local SP_u_life=display.newSprite("img/game/life2.png");
    SP_u_life:align(display.CENTER, screenW/2-130*(100-u_life)/200, screenH/2+160);
    SP_u_life:addTo(self);
    SP_u_life:setVisible(false);
	SP_u_life:setScaleX(13*u_life/100);
	SP_u_life:setScaleY(0.8);
	
	SP_u_rank_=display.newSprite("img/game/rank_BG.png");
    SP_u_rank_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_u_rank_:addTo(self);
    SP_u_rank_:setVisible(false);
	
	SP_u_rankZI=display.newSprite("#shu0.png");
    SP_u_rankZI:align(display.CENTER, screenW/2, screenH/2+160);
    SP_u_rankZI:addTo(self);
    SP_u_rankZI:setVisible(false);
	
	--:我的血条（包括等级），叠放层次在物体里最高
	local SP_I_life_=display.newSprite("img/game/life_.png");
    SP_I_life_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_I_life_:addTo(self);
    SP_I_life_:setVisible(false);
	SP_I_life_:setScaleY(2);
	
	local SP_I_life=display.newSprite("img/game/life1.png");
    SP_I_life:align(display.CENTER, screenW/2-130*(100-I_life)/200, screenH/2+160);
    SP_I_life:addTo(self);
    SP_I_life:setVisible(false);
	SP_I_life:setScaleX(13*I_life/100);
	SP_I_life:setScaleY(0.8);
	
	SP_I_rank_=display.newSprite("img/game/rank_BG.png");
    SP_I_rank_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_I_rank_:addTo(self);
    SP_I_rank_:setVisible(false);
	
	SP_I_rankZI=display.newSprite("#shu0.png");
    SP_I_rankZI:align(display.CENTER, screenW/2, screenH/2+160);
    SP_I_rankZI:addTo(self);
    SP_I_rankZI:setVisible(false);
	
	--摇杆：
	local SP_YaoGanBig=display.newSprite("img/game/YaoGanBig0.png");
    SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid, screenH/2+button_move_midYmid);
    SP_YaoGanBig:addTo(self);
    SP_YaoGanBig:setVisible(false);
	
	local SP_YaoGanSmall=display.newSprite("img/game/YaoGanSmall0.png");
    SP_YaoGanSmall:align(display.CENTER, screenW/2+button_move_midXmid, screenH/2+button_move_midYmid);
    SP_YaoGanSmall:addTo(self);
    SP_YaoGanSmall:setVisible(false);
	
	--attack按钮:
	local SP_attack1=display.newSprite("img/game/YaoGanSmall0.png");
    SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid, screenH/2+button_attack1_midYmid);
    SP_attack1:addTo(self);
    SP_attack1:setVisible(false);
    SP_attack1:setScale(3);
	
	local SP_attack2=display.newSprite("img/game/YaoGanSmall0.png");
    SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid, screenH/2+button_attack2_midYmid);
    SP_attack2:addTo(self);
    SP_attack2:setVisible(false);
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
	--debug提示字：
	--[[
	local s="";
	local ZI_= cc.ui.UILabel.new({
            UILabelType = 2,
			text = "hello",
			size = 20,
			color = cc.c3b(0, 255, 0)
			});
    ZI_:align(display.CENTER,screenW/2, screenH/2);--不可用pos
    ZI_:addTo(self);
    ZI_:setVisible(true);
    ZI_:setString(s);
	]]--
	--人物动画：
    --[图片命名为1~8 :%d]or[图片命名为01~08 :%02d]&&[图片1~8]=[1,8]&&[图片9~16]=[9（起始）,8（长度）]
	--行走：
	--[[
	local animation_XingZou_leftdown=display.newAnimation(display.newFrames("%2d-1.png",65,8),0.02);--时间间隔0.02
	local animation_XingZou_down=display.newAnimation(display.newFrames("%d-1.png",65+8,8),0.02);--时间间隔0.02
	local animation_XingZou_rightdown=display.newAnimation(display.newFrames("%d-1.png",65+16,8),0.02);--时间间隔0.02
	local animation_XingZou_right=display.newAnimation(display.newFrames("%d-1.png",65+24,8),0.02);--时间间隔0.02
	local animation_XingZou_righttop=display.newAnimation(display.newFrames("%d-1.png",65+32,8),0.02);--时间间隔0.02
	local animation_XingZou_top=display.newAnimation(display.newFrames("%d-1.png",65+40,8),0.02);--时间间隔0.02
	local animation_XingZou_lefttop=display.newAnimation(display.newFrames("%d-1.png",65+48,8),0.02);--时间间隔0.02
	local animation_XingZou_left=display.newAnimation(display.newFrames("%d-1.png",65+56,8),0.02);--时间间隔0.02
	--疗伤手势：
	local animation_LiaoShang_leftdown=display.newAnimation(display.newFrames("%d-1.png",257,8),0.02);--时间间隔0.02
	local animation_LiaoShang_down=display.newAnimation(display.newFrames("%d-1.png",257+8,8),0.02);--时间间隔0.02
	local animation_LiaoShang_rightdown=display.newAnimation(display.newFrames("%d-1.png",257+16,8),0.02);--时间间隔0.02
	local animation_LiaoShang_right=display.newAnimation(display.newFrames("%d-1.png",257+24,8),0.02);--时间间隔0.02
	local animation_LiaoShang_righttop=display.newAnimation(display.newFrames("%d-1.png",257+32,8),0.02);--时间间隔0.02
	local animation_LiaoShang_top=display.newAnimation(display.newFrames("%d-1.png",257+40,8),0.02);--时间间隔0.02
	local animation_LiaoShang_lefttop=display.newAnimation(display.newFrames("%d-1.png",257+48,8),0.02);--时间间隔0.02
	local animation_LiaoShang_left=display.newAnimation(display.newFrames("%d-1.png",257+56,8),0.02);--时间间隔0.02
	--空掌：
	local animation_KongZhang_leftdown=display.newAnimation(display.newFrames("%d-1.png",585,8),0.02);--时间间隔0.02
	local animation_KongZhang_down=display.newAnimation(display.newFrames("%d-1.png",585+8,8),0.02);--时间间隔0.02
	local animation_KongZhang_rightdown=display.newAnimation(display.newFrames("%d-1.png",585+16,8),0.02);--时间间隔0.02
	local animation_KongZhang_right=display.newAnimation(display.newFrames("%d-1.png",585+24,8),0.02);--时间间隔0.02
	local animation_KongZhang_righttop=display.newAnimation(display.newFrames("%d-1.png",585+32,8),0.02);--时间间隔0.02
	local animation_KongZhang_top=display.newAnimation(display.newFrames("%d-1.png",585+40,8),0.02);--时间间隔0.02
	local animation_KongZhang_lefttop=display.newAnimation(display.newFrames("%d-1.png",585+48,8),0.02);--时间间隔0.02
	local animation_KongZhang_left=display.newAnimation(display.newFrames("%d-1.png",585+56,8),0.02);--时间间隔0.02
	--直拳：
	local animation_ZhiQuan_leftdown=display.newAnimation(display.newFrames("%d-1.png",777,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_down=display.newAnimation(display.newFrames("%d-1.png",777+10,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_rightdown=display.newAnimation(display.newFrames("%d-1.png",777+20,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_right=display.newAnimation(display.newFrames("%d-1.png",777+30,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_righttop=display.newAnimation(display.newFrames("%d-1.png",777+40,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_top=display.newAnimation(display.newFrames("%d-1.png",777+50,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_lefttop=display.newAnimation(display.newFrames("%d-1.png",777+60,8),0.02);--时间间隔0.02
	local animation_ZhiQuan_left=display.newAnimation(display.newFrames("%d-1.png",777+70,8),0.02);--时间间隔0.02
	--人物动画end
	]]--
	
	
	
	--【摄像头定义】
	local camera = cc.Camera:createOrthographic(display.width,display.height,0,1);
	camera:setCameraFlag(cc.CameraFlag.USER1);
	self:addChild(camera);
	self:setCameraMask(2);
	camera:setPositionX(0); 
	camera:setPositionY(0);
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
    --【监听】
    local MoveDown=false;
	--one node 双触：
	self:setTouchEnabled(true);
	self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE);
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function ( event )
	    
	if caser==2 then	
	    if event.name=="began" --第一个begin（第一个点）
		or event.name=="added" then--第二个begin(全部的点)
	        --print("began");s=s.."begin\n";ZI_:setString(s);
			for id,point in pairs(event.points)do
		        --print(id);s=s..id.."\n";ZI_:setString(s);
				--如果begin点中了move按钮:----------------------------------------------
				if math.abs(point.x-screenW/2-button_move_midXmid)<button_move_R
				and math.abs(point.y-screenH/2-button_move_midYmid)<button_move_R then
					MoveDown=true;
					client_move_dir=0;
					print("movedown=true");
				end;
				-------------------------------------------------------------------------
				---------点击[攻击1按钮]-------------------------------------------------------------
				if math.abs(point.x-screenW/2-button_attack1_midXmid)<button_attack1_R
				and math.abs(point.y-screenH/2-button_attack1_midYmid)<button_attack1_R then
				    SP_attack1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("YaoGanSmall1.png"));
					--if ismoving==false then
					  --  ismoving=true;
						socket:send(ByteArray.new():writeString("F}"):getPack());
			        --end;
				end;
				-------------------------------------------------------------------------
		    end
			return true;
	    end;   
		if event.name=="removed" --部分触摸点消失（消失的点）
		or event.name=="ended" then--全部触摸点消失（全部消失的点）
	        --print("removed");s=s.."removed\n";ZI_:setString(s);
			for id,point in pairs(event.points)do
		        --print(id);s=s..id.."\n";ZI_:setString(s);
				--如果[move按钮-手指]未超过边界:----------------------------------------------
				local x_= math.abs(point.x-screenW/2-button_move_midXmid);
				local y_= math.abs(point.y-screenH/2-button_move_midYmid);
				if point.x<screenW/2 and MoveDown==true then-- 左边
					MoveDown=false;
					client_move_dir=0;
			        print("movedown=false");
			        local firstX=screenW/2+button_move_midXmid;
                    local firstY=screenH/2+button_move_midYmid;
			        SP_YaoGanSmall:align(display.CENTER, firstX+camera_midXmid, firstY+camera_midYmid);
				end;
				-------------------------------------------------------------------------
				---------[攻击1按钮]的消失-------------------------------------------------------------
				if math.abs(point.x-screenW/2-button_attack1_midXmid)<button_attack1_R
				and math.abs(point.y-screenH/2-button_attack1_midYmid)<button_attack1_R then
				    SP_attack1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("YaoGanSmall0.png"));
				end;
				-------------------------------------------------------------------------
		    end
			return true;
	    end;  
		if event.name=="moved" then--点在移动（移动的点）
	        --print("moved");s=s.."moved\n";ZI_:setString(s);
			for id,point in pairs(event.points)do
		        --print(id);s=s..id.."\n";ZI_:setString(s);
				--如果[move按钮-手指]超过边界（改变图的位置？）:----------------------------------------------
				local x_= math.abs(point.x-screenW/2-button_move_midXmid);
				local y_= math.abs(point.y-screenH/2-button_move_midYmid);
				if 1==1 
				and point.x>screenW/2 --屏幕右边：松开
				and MoveDown==true then
					MoveDown=false;
					client_move_dir=0;
					print("movedown=false");
					local firstX=screenW/2+button_move_midXmid;
                    local firstY=screenH/2+button_move_midYmid;
					SP_YaoGanSmall:align(display.CENTER, firstX+camera_midXmid, firstY+camera_midYmid);
				end;
				-------------------------------------------------------------------------
				--如果[move按钮-手指]标准位移位置控制区域（改变图的位置？）:----------------------------------------------
				local x_= math.abs(point.x-screenW/2-button_move_midXmid);
				local y_= math.abs(point.y-screenH/2-button_move_midYmid);
				if point.x<screenW/2 and MoveDown==true then-- 屏幕左边
				    movepoint_x=point.x;
				    movepoint_y=point.y;
				end;
				-------------------------------------------------------------------------
				--如果[move按钮-手指]未超过边界&&不在中间（改变方向？）:----------------------------------------------
				local x_= math.abs(point.x-screenW/2-button_move_midXmid);
				local y_= math.abs(point.y-screenH/2-button_move_midYmid);
				if 1==1
				--and x_*x_+y_*y_<=button_move_R*button_move_R-- 一倍圈里面 
				and MoveDown==true 
				and x_*x_+y_*y_>=button_move_R*button_move_R/4 then-- 0.5倍圈外
					local xx= point.x-(screenW/2+button_move_midXmid);
				    local yy= point.y-(screenH/2+button_move_midYmid);
					if xx>=0 and yy>=0 then
					    if x_/y_<0.5 then
							client_move_dir=1;
						elseif y_/x_<0.5 then
							client_move_dir=3;
						else
						    client_move_dir=2;
						end;
					end;
					if xx>=0 and yy<=0 then
					    if x_/y_<0.5 then
						    client_move_dir=5;
						elseif y_/x_<0.5 then
						    client_move_dir=3;
						else
						    client_move_dir=4;
						end;
					end;
					if xx<=0 and yy<=0 then
					    if x_/y_<0.5 then
						    client_move_dir=5;
						elseif y_/x_<0.5 then
						    client_move_dir=7;
						else
						    client_move_dir=6;
						end;
					end;
					if xx<=0 and yy>=0 then
					    if x_/y_<0.5 then
						    client_move_dir=1;
						elseif y_/x_<0.5 then
						    client_move_dir=7;
						else
						    client_move_dir=8;
						end;
					end;
				end;
				-------------------------------------------------------------------------
		    end
			return true;
	    end; 
	end;--caser==2 end
    end);--监听end

    --[[
	SP_button_giveup:setTouchEnabled(true);
    SP_button_giveup:addNodeEventListener(cc.NODE_TOUCH_EVENT,function ( event )
	    if scene_game_caser==3 then
	        GiveUp(3);
	    end;  
    end);
	]]--
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
    --【function】
local function closecaserall()--【】【】
    caser=0;
    --find game 背景：
    SP_BG_findgame:setVisible(false);
    SP_BG_findgameZI:setVisible(false);
    --------------caser分割线-------------------------
	--game背景：
    SP_background3:setVisible(false);
    SP_background2:setVisible(false);
    SP_background1:setVisible(false);
    SP_background0:setVisible(false);
	--:防御塔的攻击范围：
    SP_tower_circle1:setVisible(false);
    SP_tower_circle2:setVisible(false);
	--"你"叠放层次之上低
	SP_u_up1:setVisible(false);
	--:"我"低叠放层次
	SP_I_up:setVisible(false);
	--"你"叠放层次之上高
	SP_u_up2:setVisible(false);
	-- 小车=小兵：(包含血条)
    SP_car1:setVisible(false);
    SP_car1_life_:setVisible(false);
    SP_car1_life:setVisible(false);
    SP_car2:setVisible(false);
    SP_car2_life_:setVisible(false);
    SP_car2_life:setVisible(false);
	--:防御塔：(包含血条)
    SP_tower1:setVisible(false);
    SP_tower1_life_:setVisible(false);
    SP_tower1_life:setVisible(false);
    SP_tower2:setVisible(false);
    SP_tower2_life_:setVisible(false);
    SP_tower2_life:setVisible(false);
	--"你"叠放层次之下低
	SP_u_down1:setVisible(false);
	--:"我"高叠放层次
	SP_I_down:setVisible(false);
	--"你"叠放层次之下高
	SP_u_down2:setVisible(false);
	--:你的血条
    SP_u_rankZI:setVisible(false);
    SP_u_rank_:setVisible(false);
    SP_u_life_:setVisible(false);
    SP_u_life:setVisible(false);
	--:我的血条
    SP_I_rankZI:setVisible(false);
    SP_I_rank_:setVisible(false);
    SP_I_life_:setVisible(false);
    SP_I_life:setVisible(false);
	--摇杆：
    SP_YaoGanBig:setVisible(false);
    SP_YaoGanSmall:setVisible(false);
    SP_attack1:setVisible(false);
    SP_attack2:setVisible(false);
end;
local function opencaser1()--【】【】
    caser=1;
    --find game 背景：
    SP_BG_findgame:setVisible(true);
    SP_BG_findgameZI:setVisible(true);
end;
local function opencaser2()--【】【】
    caser=2;
	--===============================================================================================
					--游戏初始化：
					I_midXmid=-1000;
	                I_midYmid=0;
	                I_life=100;
					I_rank=0;
	                u_midXmid=1000;
	                u_midYmid=0;
	                u_life=100;
					u_rank=0;
	                car1_midXmid=-1100;
	                car1_midYmid=-280;
	                car1_life=100;
	                car2_midXmid=1100;
	                car2_midYmid=-280;
	                car2_life=100;
	                tower1_life=100;
	                tower2_life=100;
	                move_dir=0;
	                attack_dir=3;
	                u_move_dir=0;
	                u_attack_dir=3;
					camera_midXmid=-1000;
	                camera_midYmid=0;
					if sofa==2 then
					    I_midXmid=1000;
						camera_midXmid=1000;
	                    u_midXmid=-1000;
                        SP_car1_life:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("life2.png"));					
                        SP_car2_life:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("life1.png"));	
                        SP_tower1_life:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("life2.png"));					
                        SP_tower2_life:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("life1.png"));						
					end;
					SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			        SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			        SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			        SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
					camera:setPositionX(camera_midXmid); 
					SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
	--===============================================================================================
	--game背景：
    SP_background3:setVisible(true);
    SP_background2:setVisible(true);
    SP_background1:setVisible(true);
    SP_background0:setVisible(true);
	--:防御塔的攻击范围：
    SP_tower_circle1:setVisible(true);
    SP_tower_circle2:setVisible(true);
	--"你"叠放层次之上低
	SP_u_up1:setVisible(true);
	--:"我"低叠放层次
	SP_I_up:setVisible(true);
	--"你"叠放层次之上高
	SP_u_up2:setVisible(true);
	-- 小车=小兵：(包含血条)
    SP_car1:setVisible(true);
    SP_car1_life_:setVisible(true);
    SP_car1_life:setVisible(true);
    SP_car2:setVisible(true);
    SP_car2_life_:setVisible(true);
    SP_car2_life:setVisible(true);
	--:防御塔：(包含血条)
    SP_tower1:setVisible(true);
    SP_tower1_life_:setVisible(true);
    SP_tower1_life:setVisible(true);
    SP_tower2:setVisible(true);
    SP_tower2_life_:setVisible(true);
    SP_tower2_life:setVisible(true);
	--"你"叠放层次之下低
	SP_u_down1:setVisible(true);
	--:"我"高叠放层次
	SP_I_down:setVisible(true);
	--"你"叠放层次之下高
	SP_u_down2:setVisible(true);
	--:你的血条
    SP_u_rankZI:setVisible(true);
    SP_u_rank_:setVisible(true);
    SP_u_life_:setVisible(true);
    SP_u_life:setVisible(true);
	--:我的血条
    SP_I_rankZI:setVisible(true);
    SP_I_rank_:setVisible(true);
    SP_I_life_:setVisible(true);
    SP_I_life:setVisible(true);
	--摇杆：
    SP_YaoGanBig:setVisible(true);
    SP_YaoGanSmall:setVisible(true);
    SP_attack1:setVisible(true);
    --SP_attack2:setVisible(true);
end;
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
local function makesocket()--【】【】
	--print(os.date("%c"))
    --------------------------------------------------------------
	socket = SocketTCP.new("47.107.148.147",54321,false)--ALiYun1
	--socket = SocketTCP.new("106.14.181.7",54321,false)--ALiYun2
	--socket = SocketTCP.new("www.ququking.top",54321,false)--ALiYun2
	--socket = SocketTCP.new("localhost",54321,false)
	con_ok=true--客户端心跳检测{1/3}
    nettydata=""
    local function onStatues(event)--【】【】
	    if event.name == SocketTCP.EVENT_DATA then
		    --print("【" .. event.data .. "】")
			nettydata=nettydata .. event.data
			if string.sub(nettydata,string.len(nettydata),string.len(nettydata))=="}" then
			
            --print("-------------------------------------get--------------------------------------")
			--print(event.data)
            con_ok=true--客户端心跳检测{2/3}
			getdata=split(nettydata,"}")
			nettydata=""
			--print("sum:[".. table.getn(getdata) .."]")
			for i0=1,table.getn(getdata),1 do
			    if string.sub(getdata[i0],1,1)== "2" then
				    --断开连接
					socket:close()
			        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID1)
					print("账号或密码错误")
			        print(type(scheduler1))
					local newScene = import("app.scenes.HomeScene"):new()
                    display.replaceScene(newScene,"crossFade",0,0)
				end
				if string.sub(getdata[i0],1,1)== "q" then
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					--
					print("q "..s1)
					BY_qiang[tonumber(string.sub(s1,2,2))]=tonumber(string.sub(s1,1,1))
				end
				if string.sub(getdata[i0],1,1)== "L" then--大帧同步
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					local gets=split(s1,"~");
					local person1X=tonumber(gets[1]);
					local person1Y=tonumber(gets[2]);
					local person1life=tonumber(gets[3]);
					local person2X=tonumber(gets[4]);
					local person2Y=tonumber(gets[5]);
					local person2life=tonumber(gets[6]);
					local car1X=tonumber(gets[7]);
					local car1Y=tonumber(gets[8]);
					local car1life=tonumber(gets[9]);
					local car2X=tonumber(gets[10]);
					local car2Y=tonumber(gets[11]);
					local car2life=tonumber(gets[12]);
					if sofa==1 then
					    I_midXmid=person1X;
						I_midYmid=person1Y;
						I_life=person1life;
						u_midXmid=person2X;
						u_midYmid=person2Y;
						u_life=person2life;
						car1_midXmid=car1X;
						car1_midYmid=car1Y;
						car1_life=car1life;
						car2_midXmid=car2X;
						car2_midYmid=car2Y;
						car2_life=car2life;
					end;
					if sofa==2 then
					    I_midXmid=person2X;
						I_midYmid=person2Y;
						I_life=person2life;
						u_midXmid=person1X;
						u_midYmid=person1Y;
						u_life=person1life;
						car1_midXmid=car1X;
						car1_midYmid=car1Y;
						car1_life=car1life;
						car2_midXmid=car2X;
						car2_midYmid=car2Y;
						car2_life=car2life;
					end;
				end;
				if string.sub(getdata[i0],1,1)== "K" and 1==2 then--获取主要节点visible的改变
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					local gets=split(s1,"~");
					local get_fromsofa=tonumber(gets[1]);
					local get_tower_I_car=tonumber(gets[2]);
					local get_TrueFalse=tonumber(gets[3]);
					if get_fromsofa==sofa then--我的人
					    if get_tower_I_car==3 then--car
						    if get_TrueFalse==1 then--true
							    if sofa==1 then--我在sofa1=左边
							        SP_car1:setVisible(true);
							        SP_car1_life:setVisible(true);
							        SP_car1_life_:setVisible(true);
								end;
								if sofa==2 then
							        SP_car2:setVisible(true);
							        SP_car2_life:setVisible(true);
							        SP_car2_life_:setVisible(true);
								end;
							else
							    if sofa==1 then
							        SP_car1:setVisible(false);
							        SP_car1_life:setVisible(false);
							        SP_car1_life_:setVisible(false);
								end;
								if sofa==2 then
							        SP_car2:setVisible(false);
							        SP_car2_life:setVisible(false);
							        SP_car2_life_:setVisible(false);
								end;
							end;
						end;
					end;
					if get_fromsofa~=sofa then--对手的人
					    if get_tower_I_car==3 then
						    if get_TrueFalse==1 then--true
							    if sofa==1 then--我在sofa1=左边
							        SP_car2:setVisible(true);
							        SP_car2_life:setVisible(true);
							        SP_car2_life_:setVisible(true);
								end;
								if sofa==2 then
							        SP_car1:setVisible(true);
							        SP_car1_life:setVisible(true);
							        SP_car1_life_:setVisible(true);
								end;
							else
							    if sofa==1 then
							        SP_car2:setVisible(false);
							        SP_car2_life:setVisible(false);
							        SP_car2_life_:setVisible(false);
								end;
								if sofa==2 then
							        SP_car1:setVisible(false);
							        SP_car1_life:setVisible(false);
							        SP_car1_life_:setVisible(false);
								end;
							end;
						end;
					end;
				end;
				if string.sub(getdata[i0],1,1)== "D" then--对手的移动方向[0~8]
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					--print("D s1=".. s1);
					local gets=split(s1,"~");
					local get_dir=tonumber(gets[1]);
					--print("get_dir:".. get_dir);
					local get_fromsofa=tonumber(gets[2]);
					--print("get_fromsofa:".. get_fromsofa);
					if get_fromsofa==sofa then
					    move_dir=get_dir;
                        if move_dir~=0 then
					        attack_dir=move_dir;
					    end;
					end;
					if get_fromsofa~=sofa then
					    u_move_dir=get_dir;
                        if u_move_dir~=0 then
					        u_attack_dir=u_move_dir;
					    end;
					end;
				end;
				if string.sub(getdata[i0],1,1)== "F" then--对手攻击
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					local who=tonumber(s1);
					--print("who:".. who);
					--print("sofa:".. sofa);
					if who==sofa then
					if  1==1 then
				        ----【I打car2||I打car1||I打u：begin】
						--必定是8个方向中的一个，必定执行动画，必定ismoving->false
						if attack_dir==1 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_top=display.newAnimation(display.newFrames("%d-1.png",777+50,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_top,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_top,false,function() ismoving=false; end,0);
							end;
							---------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midYmid>I_midYmid-45 and y_/x_>2 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							---------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midYmid>I_midYmid-45 and y_/x_>2 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midYmid>I_midYmid and y_/x_>2 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==2 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_righttop=display.newAnimation(display.newFrames("%d-1.png",777+40,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_righttop,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_righttop,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid>I_midYmid-45 and car2_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid>I_midYmid-45 and car1_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid>I_midYmid and u_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==3 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_right=display.newAnimation(display.newFrames("%d-1.png",777+30,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_right,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_right,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midXmid>I_midXmid and y_/x_<0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midXmid>I_midXmid and y_/x_<0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midXmid>I_midXmid and y_/x_<0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==4 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_rightdown=display.newAnimation(display.newFrames("%d-1.png",777+20,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid<I_midYmid-45 and car2_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid<I_midYmid-45 and car1_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid<I_midYmid and u_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==5 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_down=display.newAnimation(display.newFrames("%d-1.png",777+10,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_down,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_down,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midYmid<I_midYmid-45 and y_/x_>2 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midYmid<I_midYmid-45 and y_/x_>2 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midYmid<I_midYmid and y_/x_>2 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==6 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_leftdown=display.newAnimation(display.newFrames("%d-1.png",777,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid<I_midYmid-45 and car2_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid<I_midYmid-45 and car1_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid<I_midYmid and u_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==7 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_left=display.newAnimation(display.newFrames("%d-1.png",777+70,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_left,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_left,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midXmid<I_midXmid and y_/x_<0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midXmid<I_midXmid and y_/x_<0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midXmid<I_midXmid and y_/x_<0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if attack_dir==8 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_lefttop=display.newAnimation(display.newFrames("%d-1.png",777+60,8),0.08);
			                    SP_I_up:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() ismoving=false; end,0);
			                    SP_I_down:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car2_midXmid);
							local y_=math.abs(I_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid>I_midYmid-45 and car2_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-car1_midXmid);
							local y_=math.abs(I_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid>I_midYmid-45 and car1_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid>I_midYmid and u_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    u_life=u_life-10;
								if u_life<0 then
								    u_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						----【I打car2||I打car1||I打u：end】
					end;--ismoving
					end;--who==sofa
					if who~=sofa then
				    if  1==1 then
						----【u打car2||u打car1||u打I：begin】
						--必定是8个方向中的一个，必定执行动画，必定u_ismoving->false
						if u_attack_dir==1 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_top=display.newAnimation(display.newFrames("%d-1.png",777+50,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_top,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_top,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_top,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_top,false,function() u_ismoving=false; end,0);
							end;
							---------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midYmid>u_midYmid-45 and y_/x_>2 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							---------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midYmid>u_midYmid-45 and y_/x_>2 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midYmid<I_midYmid and y_/x_>2 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==2 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_righttop=display.newAnimation(display.newFrames("%d-1.png",777+40,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_righttop,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_righttop,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_righttop,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_righttop,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid>u_midYmid-45 and car2_midXmid>u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid>u_midYmid-45 and car1_midXmid>u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid<I_midYmid and u_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==3 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_right=display.newAnimation(display.newFrames("%d-1.png",777+30,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_right,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_right,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_right,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_right,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midXmid>u_midXmid and y_/x_<0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midXmid>u_midXmid and y_/x_<0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midXmid<I_midXmid and y_/x_<0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==4 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_rightdown=display.newAnimation(display.newFrames("%d-1.png",777+20,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_rightdown,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid<u_midYmid-45 and car2_midXmid>u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid<u_midYmid-45 and car1_midXmid>u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid>I_midYmid and u_midXmid<I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==5 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_down=display.newAnimation(display.newFrames("%d-1.png",777+10,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_down,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_down,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_down,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_down,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midYmid<u_midYmid-45 and y_/x_>2 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midYmid<u_midYmid-45 and y_/x_>2 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midYmid>I_midYmid and y_/x_>2 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==6 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_leftdown=display.newAnimation(display.newFrames("%d-1.png",777,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_leftdown,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid<u_midYmid-45 and car2_midXmid<u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid<u_midYmid-45 and car1_midXmid<u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid>I_midYmid and u_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==7 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_left=display.newAnimation(display.newFrames("%d-1.png",777+70,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_left,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_left,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_left,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_left,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 and car2_midXmid<u_midXmid and y_/x_<0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 and car1_midXmid<u_midXmid and y_/x_<0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 and u_midXmid>I_midXmid and y_/x_<0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						if u_attack_dir==8 then
						    ----------------------------------------------------------------------------------------------
							if ismoving==false then
					            ismoving=true;
						        local animation_ZhiQuan_lefttop=display.newAnimation(display.newFrames("%d-1.png",777+60,8),0.08);
			                    SP_u_up1:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() u_ismoving=false; end,0);
			                    SP_u_up2:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() u_ismoving=false; end,0);
			                    SP_u_down1:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() u_ismoving=false; end,0);
			                    SP_u_down2:playAnimationOnce(animation_ZhiQuan_lefttop,false,function() u_ismoving=false; end,0);
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car2_midXmid);
							local y_=math.abs(u_midYmid-45-car2_midYmid);
							if x_*x_+y_*y_<200*200 
							and car2_midYmid>u_midYmid-45 and car2_midXmid<u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car2_life=car2_life-10;
								if car2_life<0 then
								    car2_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(u_midXmid-car1_midXmid);
							local y_=math.abs(u_midYmid-45-car1_midYmid);
							if x_*x_+y_*y_<200*200 
							and car1_midYmid>u_midYmid-45 and car1_midXmid<u_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    car1_life=car1_life-10;
								if car1_life<0 then
								    car1_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
							local x_=math.abs(I_midXmid-u_midXmid);
							local y_=math.abs(I_midYmid-u_midYmid);
							if x_*x_+y_*y_<200*200 
							and u_midYmid<I_midYmid and u_midXmid>I_midXmid 
							and y_/x_<2 and y_/x_>0.5 then
							    I_life=I_life-10;
								if I_life<0 then
								    I_life=0;
								end;
							end;
							----------------------------------------------------------------------------------------------
						end;
						----【u打car2||u打car1||u打I：end】
			        end;--if u_ismoving==false
					end;--if who~=sofa
				end;
				if string.sub(getdata[i0],1,1)== "P"  then
				print("\nget P")
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					
					--分开数据
				    datat=split(s1,"\n")
					--
					local P_sofa=tonumber(datat[1])
					local P_link_ready_=datat[2]--"0" or "1"
					local P_money0=datat[3]--压缩数据
					local P_name=datat[4]
					local P_photo0=datat[5]--压缩数据
					
					local i
					for i=1,string.len(P_money0),1 do
					--print("ascii".. (tonumber(string.byte(string.sub(P_money0,i,i)))-23))
					end
					----------------------------------------
					--解压缩数据
					local function webCHARtoNUMBER0to99(c)
						return string.byte(c)-23
                    end
					local function webSTRINGtoINT(s)
					--print("(1689line)s:".. s)
					    local i
						local sum=0
						for i=1,string.len(s),1 do
						    sum=sum*100+webCHARtoNUMBER0to99(string.sub(s,i,i))
						end
						return sum
					end
					----------------------------------------
					
					local P_money=webSTRINGtoINT(P_money0)
					local P_photo=webSTRINGtoINT(P_photo0)
					
					print("sofa:".. P_sofa)
					print("link ready :".. P_link_ready_)
					print("money:".. P_money)
					print("name:".. P_name)
					print("photo:".. P_photo)
					
					BY_link[P_sofa]=tonumber(string.sub(P_link_ready_,1,1))
					BY_ready[P_sofa]=tonumber(string.sub(P_link_ready_,2,2))
					BY_money[P_sofa]=P_money
					BY_name[P_sofa]=P_name
					BY_photo[P_sofa]=P_photo
					
				end
			    if string.sub(getdata[i0],1,1)== "T" then
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]));
					--
					--获取timer作为client的timer
					casert=tonumber(s1);
					print("\nget t:".. casert);
					if casert==1 then
					    closecaserall();
						opencaser2();
					end;
					function_timer();
			    end;
				if string.sub(getdata[i0],1,1)=="3" then
				    --获取去掉开头的部分:
				    local s1=string.sub(getdata[i0],2,string.len(getdata[i0]))
					--分开数据
				    local s2=split(s1,"~")
					room=tonumber(s2[1]);print("room:" .. room);
					sofa=tonumber(s2[2]);print("sofa:" .. sofa);
					--===============================================================================================
					socket:send(ByteArray.new():writeString("R}"):getPack());--告诉服务器准备完毕
					--===============================================================================================
	--##########################################################################################
	timer=0
	scheduler1 = cc.Director:getInstance():getScheduler()
    schedulerID1=nil--不可少
	schedulerID1 = scheduler1:scheduleScriptFunc(function() 
		----------------------------------------------------------------------------------------
	    timer=timer+1
		----------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------
		--【即时数据沟通】
		if timer%1==0 then
		    --socket:send(ByteArray.new():writeString("T}"):getPack())
			--print("send T")
		end
		----------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------		
		if timer%100==0 and 1==2 then 
		    --【【客户端心跳检测{3/3}  写在timer最前面 
			if con_ok==false then
			    print("heart client close".. os.date("%c"))
                socket:close()
			    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID1)	
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID0)
				local newScene = import("app.scenes.HomeScene"):new()
                display.replaceScene(newScene,"crossFade",0,0)
			end
			if con_ok==true then con_ok=false end
			--】】
			--print("socket.type=".. type(socket))--未知类似断网问题
		    --socket:send(ByteArray.new():writeString("X}"):getPack())--服务端心跳检测
		end
		----------------------------------------------------------------------------------------
	end,0.02,false)
	----------------------------------------------------------
	--##########################################################################################
	
				end
			end
			end
	    end
	    if event.name == SocketTCP.EVENT_CONNECTED then
	        socket:send(ByteArray.new():writeString("1"..id_.."~"..password_.."}"):getPack())
			print("send first:".."1"..id_.."~"..password_.."}")
	    end
	    if event.name == SocketTCP.EVENT_CLOSE then
	        print("close"..tostring(sum))
	    end
	    if event.name == SocketTCP.EVENT_CLOSED then
		    print("closed")
	        socket = nil
	    end
    end	
    socket:addEventListener(SocketTCP.EVENT_CONNECTED,onStatues)--链接成功
    socket:addEventListener(SocketTCP.EVENT_CLOSE,onStatues)--链接即将关闭
    socket:addEventListener(SocketTCP.EVENT_CLOSED,onStatues)--链接已经关闭
    socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE,onStatues)--连接服务器失败
    socket:addEventListener(SocketTCP.EVENT_DATA,onStatues)--接收到服务器的数据，存放在event.data
    socket:connect()
end--function
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
function function_timer()
	if caser==2 then	
	if casert==0 then 
	else
	    --casert递增：----------------
		casert=casert+1;
		if casert>10000000 then 
		    casert=1; 
		end;
		------------------------------
		--【小车显示层初始化】begin
		SP_car1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car1.png"));
		SP_car2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car2.png"));
		--【小车显示层初始化】end
		--【小车的显示与消失】begin
		                        if car1_life>0 then
							        SP_car1:setVisible(true);
							        SP_car1_life:setVisible(true);
							        SP_car1_life_:setVisible(true);
								end;
								if car2_life>0 then
							        SP_car2:setVisible(true);
							        SP_car2_life:setVisible(true);
							        SP_car2_life_:setVisible(true);
								end;
							    if car1_life<=0 then
							        SP_car1:setVisible(false);
							        SP_car1_life:setVisible(false);
							        SP_car1_life_:setVisible(false);
								end;
								if car2_life<=0 then
							        SP_car2:setVisible(false);
							        SP_car2_life:setVisible(false);
							        SP_car2_life_:setVisible(false);
								end;
		--【小车的显示与消失】end
		--【小车的生成】begin
		if car1_life<=0 and car2_life<=0 then
		    car1_life=100;
			car2_life=100;
			car1_midXmid=-1200;
			car2_midXmid=1200;
		end;
		--【小车的生成】end
		--【英雄的死亡与升级】begin
		if I_life<=0 and sofa==1 then
		    u_rank=u_rank+1;
			if u_rank>=10 then
			    u_rank=9;
			end;
			SP_u_rankZI:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("shu" .. u_rank .. ".png"));
		    I_life=100;
			I_midXmid=-(worldW/2-screenW/2);
			I_midYmid=0;
			camera_midXmid=-(worldW/2-screenW/2);
	        camera_midYmid=0;
			        SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			        SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			        SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			        SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
					camera:setPositionX(camera_midXmid); 
					camera:setPositionY(camera_midYmid); 
					SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
		end;
		if I_life<=0 and sofa==2 then
		    u_rank=u_rank+1;
			if u_rank>=10 then
			    u_rank=9;
			end;
			SP_u_rankZI:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("shu" .. u_rank .. ".png"));
		    I_life=100;
			I_midXmid=(worldW/2-screenW/2);
			I_midYmid=0;
			camera_midXmid=(worldW/2-screenW/2);
	        camera_midYmid=0;
			        SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			        SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			        SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			        SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
					camera:setPositionX(camera_midXmid); 
					camera:setPositionY(camera_midYmid); 
					SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
					SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
		end;
		if u_life<=0 and sofa==1 then
		    I_rank=I_rank+1;
			if I_rank>=10 then
			    I_rank=9;
			end;
			SP_I_rankZI:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("shu" .. I_rank .. ".png"));
		    u_life=100;
			u_midXmid=(worldW/2-screenW/2);
			u_midYmid=0;
					SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
		end;
		if u_life<=0 and sofa==2 then
		    I_rank=I_rank+1;
			if I_rank>=10 then
			    I_rank=9;
			end;
			SP_I_rankZI:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("shu" .. I_rank .. ".png"));
		    u_life=100;
			u_midXmid=-(worldW/2-screenW/2);
			u_midYmid=0;
					SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			        SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
		end;
		--【英雄的死亡与升级】end
		--【英雄的生命恢复】begin
		if I_life>0 and I_life<100 then
		    I_life=I_life+0.05*I_rank;
			if I_life>100 then I_life=100 end;
		end;
		if u_life>0 and u_life<100 then
		    u_life=u_life+0.05*u_rank;
			if u_life>100 then u_life=100 end;
		end;
		--【英雄的生命恢复】end
	    --【小车打防御塔】begin
		if car1_life>0 and car1_midXmid>1000 then
		    tower2_life=tower2_life-0.05;
			SP_tower2_life:align(display.CENTER, screenW/2+1200-130*(100-tower2_life)/200, screenH/2-280+80);
			SP_tower2_life:setScaleX(13*tower2_life/100);
			if casert%10==0 then 
				SP_car1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car1_attack.png"));
			end;
		end;
		if car2_life>0 and car2_midXmid<-1000 then
		    tower1_life=tower1_life-0.05;
			SP_tower1_life:align(display.CENTER, screenW/2-1200-130*(100-tower1_life)/200, screenH/2-280+80);
			SP_tower1_life:setScaleX(13*tower1_life/100);
			if casert%10==0 then 
				SP_car2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car2_attack.png"));
			end;
		end;
	    --【小车打防御塔】end
	    --【防御塔打小车】begin
		if car1_life>0 and car1_midXmid>400 then
		    car1_life=car1_life-0.05;
			SP_car1_life:align(display.CENTER, screenW/2+car1_midXmid-130*(100-car1_life)/200, screenH/2+car1_midYmid+80);
			SP_car1_life:setScaleX(13*car1_life/100);
		end;
		if car2_life>0 and car2_midXmid<-400 then
		    car2_life=car2_life-0.05;
			SP_car2_life:align(display.CENTER, screenW/2+car2_midXmid-130*(100-car2_life)/200, screenH/2+car2_midYmid+80);
			SP_car2_life:setScaleX(13*car2_life/100);
		end;
	    --【防御塔打小车】end
		--【防御塔打英雄】begin
		if sofa==1 then
		    if I_life>0 and I_midXmid>400 and I_midXmid<400+325*5 then
		        I_life=I_life-1;
		    end;
		    if u_life>0 and u_midXmid<-400 and u_midXmid>-(400+325*5) then
		        u_life=u_life-1;
		    end;
		end;
		if sofa==2 then
		    if u_life>0 and u_midXmid>400 and u_midXmid<400+325*5 then
		        u_life=u_life-1;
		    end;
		    if I_life>0 and I_midXmid<-400 and I_midXmid>-(400+325*5) then
		        I_life=I_life-1;
		    end;
		end;
	    --【防御塔打英雄】end
	    --【英雄血条等级的更新】begin
		SP_I_life:align(display.CENTER, screenW/2+I_midXmid-130*(100-I_life)/200, screenH/2+I_midYmid+160);
		SP_I_life:setScaleX(13*I_life/100);
		SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
		SP_I_rank_:align(display.CENTER, screenW/2+I_midXmid-70, screenH/2+I_midYmid+160);
		SP_I_rankZI:align(display.CENTER, screenW/2+I_midXmid-70, screenH/2+I_midYmid+160);
		SP_u_life:align(display.CENTER, screenW/2+u_midXmid-130*(100-u_life)/200, screenH/2+u_midYmid+160);
		SP_u_life:setScaleX(13*u_life/100);
		SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
		SP_u_rank_:align(display.CENTER, screenW/2+u_midXmid-70, screenH/2+u_midYmid+160);
		SP_u_rankZI:align(display.CENTER, screenW/2+u_midXmid-70, screenH/2+u_midYmid+160);
	    --【英雄血条的更新】end
	    --【小车打小车】begin
		if car1_life>0 and car2_life>0 then
		    if car2_midXmid<90 and car1_midXmid>-90 then
			    car1_life=car1_life-0.1;
			    car2_life=car2_life-0.1;
				SP_car1_life:align(display.CENTER, screenW/2+car1_midXmid-130*(100-car1_life)/200, screenH/2+car1_midYmid+80);
				SP_car1_life:setScaleX(13*car1_life/100);
				SP_car2_life:align(display.CENTER, screenW/2+car2_midXmid-130*(100-car2_life)/200, screenH/2+car2_midYmid+80);
				SP_car2_life:setScaleX(13*car2_life/100);
				if casert%10==0 then 
				    SP_car1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car1_attack.png"));
					SP_car2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car2_attack.png"));
				end;
			end;
		end;
	    --【小车打小车】end
	    --【小车的移动】begin
		if car1_life>0 then
		    if (car2_life>0 and car1_midXmid<-80)or(car2_life<=0 and car1_midXmid<1050) then
				car1_midXmid=car1_midXmid+1;
				SP_car1:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid);
				SP_car1_life_:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid+80);
				SP_car1_life:align(display.CENTER, screenW/2+car1_midXmid-130*(100-car1_life)/200, screenH/2+car1_midYmid+80);
				SP_car1_life:setScaleX(13*car1_life/100);
			end;
		end;
		if car2_life>0 then
		    if (car1_life>0 and car2_midXmid>80)or(car1_life<=0 and car2_midXmid>-1050) then
				car2_midXmid=car2_midXmid-1;
				SP_car2:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid);
				SP_car2_life_:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid+80);
				SP_car2_life:align(display.CENTER, screenW/2+car2_midXmid-130*(100-car2_life)/200, screenH/2+car2_midYmid+80);
				SP_car2_life:setScaleX(13*car2_life/100);
			end;
		end;
	    --【小车的移动】end
	    --【显示层的叠放层次控制(I与世界)】begin
		if I_midYmid+screenH/2-45>screenH/2-235 then--70为显示层人物高度。280为地面（非背景）世界height的中间位置，也是防御塔和小兵的位置
		    SP_I_up:setVisible(true);
		    SP_I_down:setVisible(false);
		else
		    SP_I_up:setVisible(false);
		    SP_I_down:setVisible(true);
		end;
	    --【显示层的叠放层次控制(I与世界)】end
		--【显示层的叠放层次控制(u与I+世界)】begin
		SP_u_up1:setVisible(false);
		SP_u_up2:setVisible(false);
		SP_u_down1:setVisible(false);
		SP_u_down2:setVisible(false);
		if u_midYmid+screenH/2-45>screenH/2-235 then--70为显示层人物高度。280为地面（非背景）世界height的中间位置，也是防御塔和小兵的位置
		    if I_midYmid>u_midYmid then
			    SP_u_up2:setVisible(true);
			else    
				SP_u_up1:setVisible(true);
			end;
		else
		    if I_midYmid>u_midYmid then
			    SP_u_down2:setVisible(true);
			else    
				SP_u_down1:setVisible(true);
			end;
		end;
	    --【显示层的叠放层次控制(u与I+世界)】end
		--【把改变后的主角方向发送到服务器begin】
		if direction_to_server~=client_move_dir then
		    socket:send(ByteArray.new():writeString("D".. client_move_dir .."}"):getPack());
			direction_to_server=client_move_dir;
			print("dir change and send to server");
		end;
		--【把改变后的主角方向发送到服务器end】
		--【玩家输入层：玩家输入改变显示层begin】
		--小摇杆位置辅助begin
	    local x_= math.abs(movepoint_x-screenW/2-button_move_midXmid);
		local y_= math.abs(movepoint_y-screenH/2-button_move_midYmid);
				if x_*x_+y_*y_>=button_move_R*button_move_R and MoveDown==true then-- 一倍圈外
					local bei=((x_*x_+y_*y_)^(1/2))/button_move_R;
					x_=x_/bei;
					y_=y_/bei;
					if movepoint_x-screenW/2-button_move_midXmid>0 then 
					    movepoint_x=screenW/2+button_move_midXmid+x_;
					else
					    movepoint_x=screenW/2+button_move_midXmid-x_;
					end;
					if movepoint_y-screenH/2-button_move_midYmid>0 then 
					    movepoint_y=screenH/2+button_move_midYmid+y_;
					else
					    movepoint_y=screenH/2+button_move_midYmid-y_;
					end;
				end;
		--小摇杆位置辅助end
	    if client_move_dir==1 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==2 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==3 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==4 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==5 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==6 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==7 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		if client_move_dir==8 then
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
		end;
		--【玩家输入层：玩家输入改变显示层end】
		--【根据服务端传来的数据进行I的8方向移动begin】
		if move_dir==0 then
		    --socket:send(ByteArray.new():writeString("D0}"):getPack());
		end;
	    if move_dir==1 then
		    --socket:send(ByteArray.new():writeString("D1}"):getPack());
		    if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+3; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+3; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_top=display.newAnimation(display.newFrames("%d-1.png",65+40,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_top,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_top,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==2 then
		    --socket:send(ByteArray.new():writeString("D2}"):getPack());
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+2;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+2; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+2; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_righttop=display.newAnimation(display.newFrames("%d-1.png",65+32,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_righttop,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_righttop,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==3 then
		    --socket:send(ByteArray.new():writeString("D3}"):getPack());
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+3;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+3; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_right=display.newAnimation(display.newFrames("%d-1.png",65+24,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_right,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_right,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==4 then
		    --socket:send(ByteArray.new():writeString("D4}"):getPack());
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+2;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+2; 
			end;
			if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-2;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_rightdown=display.newAnimation(display.newFrames("%d-1.png",65+16,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_rightdown,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_rightdown,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==5 then
		    --socket:send(ByteArray.new():writeString("D5}"):getPack());
		    if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-3;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-3; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_down=display.newAnimation(display.newFrames("%d-1.png",65+8,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_down,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_down,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==6 then
		    --socket:send(ByteArray.new():writeString("D6}"):getPack());
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-2;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-2; 
			end;
			if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-2;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_leftdown=display.newAnimation(display.newFrames("%2d-1.png",65,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_leftdown,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_leftdown,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==7 then
		    --socket:send(ByteArray.new():writeString("D7}"):getPack());
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-3;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-3; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_left=display.newAnimation(display.newFrames("%d-1.png",65+56,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_left,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_left,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==8 then
		    --socket:send(ByteArray.new():writeString("D8}"):getPack());
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-2;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-2; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+2; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			if ismoving==false  then
			    ismoving=true;
			    local animation_XingZou_lefttop=display.newAnimation(display.newFrames("%d-1.png",65+48,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_lefttop,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_lefttop,false,function() ismoving=false; end,0);
			end;
		end;
		--【根据服务端传来的数据进行I的8方向移动end】
		--【根据服务端传来的数据进行u的8方向移动begin】
		if u_move_dir==1 then
		    if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+3; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_top=display.newAnimation(display.newFrames("%d-1.png",65+40,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_top,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_top,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_top,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_top,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==2 then
		    if u_midXmid<worldW/2 then
		        u_midXmid=u_midXmid+2;
			end;
			if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+2; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_righttop=display.newAnimation(display.newFrames("%d-1.png",65+32,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_righttop,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_righttop,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_righttop,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_righttop,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==3 then
		    if u_midXmid<worldW/2 then
		        u_midXmid=u_midXmid+3;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_right=display.newAnimation(display.newFrames("%d-1.png",65+24,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_right,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_right,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_right,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_right,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==4 then
		    if u_midXmid<worldW/2 then
		        u_midXmid=u_midXmid+2;
			end;
			if u_midYmid>-(worldH/2-130) then
			    u_midYmid=u_midYmid-2;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_rightdown=display.newAnimation(display.newFrames("%d-1.png",65+16,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_rightdown,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_rightdown,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_rightdown,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_rightdown,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==5 then
		    if u_midYmid>-(worldH/2-130) then
			    u_midYmid=u_midYmid-3;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_down=display.newAnimation(display.newFrames("%d-1.png",65+8,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_down,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_down,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_down,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_down,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==6 then
		    if u_midXmid>-(worldW/2) then
			    u_midXmid=u_midXmid-2;
			end;
			if u_midYmid>-(worldH/2-130) then
			    u_midYmid=u_midYmid-2;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_leftdown=display.newAnimation(display.newFrames("%2d-1.png",65,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_leftdown,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_leftdown,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_leftdown,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_leftdown,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==7 then
		    if u_midXmid>-(worldW/2) then
			    u_midXmid=u_midXmid-3;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_left=display.newAnimation(display.newFrames("%d-1.png",65+56,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_left,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_left,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_left,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_left,false,function() u_ismoving=false; end,0);
			end;
		end;
		if u_move_dir==8 then
		    if u_midXmid>-(worldW/2) then
			    u_midXmid=u_midXmid-2;
			end;
			if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+2; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			if u_ismoving==false  then
			    u_ismoving=true;
			    local animation_XingZou_lefttop=display.newAnimation(display.newFrames("%d-1.png",65+48,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			end;
		end;
		--【根据服务端传来的数据进行u的8方向移动end】
	end;--casert==0
	end;--caser==2
end;
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
    --【load】
    -----------------------永远可见
    --SP_background3:setVisible(true);
    ----------------------opencaser0
    closecaserall();
	opencaser1();
	makesocket();
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
    --【timer】
	local scheduler = cc.Director:getInstance():getScheduler();
    schedulerID=nil;--不可省略，如果省略会导致“停止”失效
    schedulerID = scheduler:scheduleScriptFunc(function()
	    
----------------------------------------------------------------------------------------------------------------[caser==2]begin
--function_timer();
-----------------------------------------------------------------------------------------------------------------[caser==2]end
    end,0.05,false);
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
--==================================================================================================================================
end;--main end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
