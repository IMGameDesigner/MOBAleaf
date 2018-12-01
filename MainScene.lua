
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    --【不变数据】
    local personX={110,110,640,1190,1190};--人头像位置
    local personY={560,320,150,320,560};
	local worldW=4320;
	local worldH=1500;
	local screenW=1920;
	local screenH=1080;
	local button_move_R=190/2;
	local button_move_midXmid=-700;
	local button_move_midYmid=-280;
	local button_attack1_midXmid=700;
	local button_attack1_midYmid=-280;
	local button_attack2_midXmid=840;
	local button_attack2_midYmid=-420;
	local I_midXmid=0;
	local I_midYmid=0;
	local I_life=100;
	local u_midXmid=0;
	local u_midYmid=0;
	local u_life=100;
	local car1_midXmid=-1100;
	local car1_midYmid=-280;
	local car1_life=100;
	local car2_midXmid=1100;
	local car2_midYmid=-280;
	local car2_life=10;
	local tower1_life=100;
	local tower2_life=100;
	local camera_midXmid=0;
	local camera_midYmid=0;
	local move_dir=0;
	local u_move_dir=0;
	local ismoving=false;
	local u_ismoving=false;
	local casert=0;
    --【限制】
    display.addSpriteFrames("img/animation/animate_I.plist","img/animation/animate_I.pvr.ccz");
	display.addSpriteFrames("img/plist/car.plist","img/plist/car.png");
    math.randomseed(os.time());
    math.random(1,10000);
	
    --【数据】
    local pai1={311,311,311,311,311};
    local pai2={311,311,311,311,311};
    local pai3={311,311,311,311,311};
	local movepoint_x=0;
	local movepoint_y=0;
    --【预加载】
	--背景：
    local SP_background3=display.newSprite("img/game/BG3.png");
    SP_background3:align(display.CENTER, screenW/2, screenH/2);
    SP_background3:addTo(self);
    SP_background3:setVisible(true);
	
	local SP_background2=display.newSprite("img/game/BG2.png");
    SP_background2:align(display.CENTER, screenW/2, screenH/2);
    SP_background2:addTo(self);
    SP_background2:setVisible(true);
	
	local SP_background1=display.newSprite("img/game/BG1.png");
    SP_background1:align(display.CENTER, screenW/2, screenH/2);
    SP_background1:addTo(self);
    SP_background1:setVisible(true);
	
	local SP_background0=display.newSprite("img/game/BG0.png");
    SP_background0:align(display.CENTER, screenW/2, screenH/2);
    SP_background0:addTo(self);
    SP_background0:setVisible(false);
	--:防御塔的攻击范围：
	local SP_tower_circle1=display.newSprite("img/game/tower_circle1.png");
    SP_tower_circle1:align(display.CENTER, screenW/2-1200, screenH/2-350);
    SP_tower_circle1:addTo(self);
    SP_tower_circle1:setVisible(true);
	SP_tower_circle1:setScale(5);
	
	local SP_tower_circle2=display.newSprite("img/game/tower_circle2.png");
    SP_tower_circle2:align(display.CENTER, screenW/2+1200, screenH/2-350);
    SP_tower_circle2:addTo(self);
    SP_tower_circle2:setVisible(true);
	SP_tower_circle2:setScale(5);
	
	--"你"叠放层次之上低
	local SP_u_up1=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_up1:align(display.CENTER, screenW/2, screenH/2);
	SP_u_up1:addTo(self);
	SP_u_up1:setVisible(true);
	SP_u_up1:setScale(3);
	
	--:"我"低叠放层次
	local SP_I_up=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_I_up:align(display.CENTER, screenW/2, screenH/2);
	SP_I_up:addTo(self);
	SP_I_up:setVisible(true);
	SP_I_up:setScale(3);
	
	--"你"叠放层次之上高
	local SP_u_up2=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_up2:align(display.CENTER, screenW/2, screenH/2);
	SP_u_up2:addTo(self);
	SP_u_up2:setVisible(true);
	SP_u_up2:setScale(3);
	
	-- 小车=小兵：(包含血条)
	local SP_car1=display.newSprite("img/game/car1.png");
    SP_car1:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid);
    SP_car1:addTo(self);
    SP_car1:setVisible(true);
	SP_car1:setScale(3);
	
	local SP_car1_life_=display.newSprite("img/game/life_.png");
    SP_car1_life_:align(display.CENTER, screenW/2+car1_midXmid, screenH/2+car1_midYmid+80);
    SP_car1_life_:addTo(self);
    SP_car1_life_:setVisible(true);
	
	local SP_car1_life=display.newSprite("img/game/life1.png");
    SP_car1_life:align(display.CENTER, screenW/2+car1_midXmid-130*(100-car1_life)/200, screenH/2+car1_midYmid+80);
    SP_car1_life:addTo(self);
    SP_car1_life:setVisible(true);
	SP_car1_life:setScaleX(13*car1_life/100);
	SP_car1_life:setScaleY(0.4);
	
	local SP_car2=display.newSprite("img/game/car2.png");
    SP_car2:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid);
    SP_car2:addTo(self);
    SP_car2:setVisible(true);
	SP_car2:setScale(3);
	
	local SP_car2_life_=display.newSprite("img/game/life_.png");
    SP_car2_life_:align(display.CENTER, screenW/2+car2_midXmid, screenH/2+car2_midYmid+80);
    SP_car2_life_:addTo(self);
    SP_car2_life_:setVisible(true);
	
	local SP_car2_life=display.newSprite("img/game/life2.png");
    SP_car2_life:align(display.CENTER, screenW/2+car2_midXmid-130*(100-car2_life)/200, screenH/2+car2_midYmid+80);
    SP_car2_life:addTo(self);
    SP_car2_life:setVisible(true);
	SP_car2_life:setScaleX(13*car2_life/100);
	SP_car2_life:setScaleY(0.4);
	
	--:防御塔：(包含血条)
	local SP_tower1=display.newSprite("img/game/tower1.png");
    SP_tower1:align(display.CENTER, screenW/2-1200, screenH/2-280);
    SP_tower1:addTo(self);
    SP_tower1:setVisible(true);
	
	local SP_tower1_life_=display.newSprite("img/game/life_.png");
    SP_tower1_life_:align(display.CENTER, screenW/2-1200, screenH/2-280+80);
    SP_tower1_life_:addTo(self);
    SP_tower1_life_:setVisible(true);
	SP_tower1_life_:setScaleY(2);
	
	local SP_tower1_life=display.newSprite("img/game/life1.png");
    SP_tower1_life:align(display.CENTER, screenW/2-1200-130*(100-tower1_life)/200, screenH/2-280+80);
    SP_tower1_life:addTo(self);
    SP_tower1_life:setVisible(true);
	SP_tower1_life:setScaleX(13*tower1_life/100);
	SP_tower1_life:setScaleY(0.8);
	
	local SP_tower2=display.newSprite("img/game/tower2.png");
    SP_tower2:align(display.CENTER, screenW/2+1200, screenH/2-280);
    SP_tower2:addTo(self);
    SP_tower2:setVisible(true);
	
	local SP_tower2_life_=display.newSprite("img/game/life_.png");
    SP_tower2_life_:align(display.CENTER, screenW/2+1200, screenH/2-280+80);
    SP_tower2_life_:addTo(self);
    SP_tower2_life_:setVisible(true);
	SP_tower2_life_:setScaleY(2);
	
	local SP_tower2_life=display.newSprite("img/game/life2.png");
    SP_tower2_life:align(display.CENTER, screenW/2+1200-130*(100-tower2_life)/200, screenH/2-280+80);
    SP_tower2_life:addTo(self);
    SP_tower2_life:setVisible(true);
	SP_tower2_life:setScaleX(13*tower2_life/100);
	SP_tower2_life:setScaleY(0.8);
	
	--"你"叠放层次之下低
	local SP_u_down1=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_down1:align(display.CENTER, screenW/2, screenH/2);
	SP_u_down1:addTo(self);
	SP_u_down1:setVisible(true);
	SP_u_down1:setScale(3);
	
	--:"我"高叠放层次
	local SP_I_down=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_I_down:align(display.CENTER, screenW/2, screenH/2);
	SP_I_down:addTo(self);
	SP_I_down:setVisible(true);
	SP_I_down:setScale(3);
	
	--"你"叠放层次之下高
	local SP_u_down2=display.newSprite("#65-1.png");--也可以用来创建Sprite
	SP_u_down2:align(display.CENTER, screenW/2, screenH/2);
	SP_u_down2:addTo(self);
	SP_u_down2:setVisible(true);
	SP_u_down2:setScale(3);
	
	--:你的血条，叠放层次仅次于我的血条
	local SP_u_life_=display.newSprite("img/game/life_.png");
    SP_u_life_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_u_life_:addTo(self);
    SP_u_life_:setVisible(true);
	SP_u_life_:setScaleY(2);
	
	local SP_u_life=display.newSprite("img/game/life2.png");
    SP_u_life:align(display.CENTER, screenW/2-130*(100-u_life)/200, screenH/2+160);
    SP_u_life:addTo(self);
    SP_u_life:setVisible(true);
	SP_u_life:setScaleX(13*u_life/100);
	SP_u_life:setScaleY(0.8);
	
	--:我的血条，叠放层次在物体里最高
	local SP_I_life_=display.newSprite("img/game/life_.png");
    SP_I_life_:align(display.CENTER, screenW/2, screenH/2+160);
    SP_I_life_:addTo(self);
    SP_I_life_:setVisible(true);
	SP_I_life_:setScaleY(2);
	
	local SP_I_life=display.newSprite("img/game/life1.png");
    SP_I_life:align(display.CENTER, screenW/2-130*(100-I_life)/200, screenH/2+160);
    SP_I_life:addTo(self);
    SP_I_life:setVisible(true);
	SP_I_life:setScaleX(13*I_life/100);
	SP_I_life:setScaleY(0.8);
	
	--摇杆：
	local SP_YaoGanBig=display.newSprite("img/game/YaoGanBig0.png");
    SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid, screenH/2+button_move_midYmid);
    SP_YaoGanBig:addTo(self);
    SP_YaoGanBig:setVisible(true);
	
	local SP_YaoGanSmall=display.newSprite("img/game/YaoGanSmall0.png");
    SP_YaoGanSmall:align(display.CENTER, screenW/2+button_move_midXmid, screenH/2+button_move_midYmid);
    SP_YaoGanSmall:addTo(self);
    SP_YaoGanSmall:setVisible(true);
	
	--attack按钮:
	local SP_attack1=display.newSprite("img/game/YaoGanSmall0.png");
    SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid, screenH/2+button_attack1_midYmid);
    SP_attack1:addTo(self);
    SP_attack1:setVisible(true);
	
	local SP_attack2=display.newSprite("img/game/YaoGanSmall0.png");
    SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid, screenH/2+button_attack2_midYmid);
    SP_attack2:addTo(self);
    SP_attack2:setVisible(true);
	
	--debug提示字：
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
	]]--
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
	
	
	
	
	--【摄像头定义】
	local camera = cc.Camera:createOrthographic(display.width,display.height,0,1);
	camera:setCameraFlag(cc.CameraFlag.USER1);
	self:addChild(camera);
	self:setCameraMask(2);
	camera:setPositionX(0); 
	camera:setPositionY(0);
    --【监听】
    local MoveDown=false;
	--one node 双触：
	self:setTouchEnabled(true);
	self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE);
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function ( event )
	    
	    if event.name=="began" --第一个begin（第一个点）
		or event.name=="added" then--第二个begin(全部的点)
	        --print("began");s=s.."begin\n";ZI_:setString(s);
			for id,point in pairs(event.points)do
		        --print(id);s=s..id.."\n";ZI_:setString(s);
				--如果begin点中了move按钮:----------------------------------------------
				if math.abs(point.x-screenW/2-button_move_midXmid)<button_move_R
				and math.abs(point.y-screenH/2-button_move_midYmid)<button_move_R then
					MoveDown=true;move_dir=0;
					print("movedown=true");
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
					MoveDown=false;move_dir=0;
			        print("movedown=false");
			        local firstX=screenW/2+button_move_midXmid;
                    local firstY=screenH/2+button_move_midYmid;
			        SP_YaoGanSmall:align(display.CENTER, firstX+camera_midXmid, firstY+camera_midYmid);
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
					MoveDown=false;move_dir=0;
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
							move_dir=1;
						elseif y_/x_<0.5 then
							move_dir=3;
						else
						    move_dir=2;
						end;
					end;
					if xx>=0 and yy<=0 then
					    if x_/y_<0.5 then
						    move_dir=5;
						elseif y_/x_<0.5 then
						    move_dir=3;
						else
						    move_dir=4;
						end;
					end;
					if xx<=0 and yy<=0 then
					    if x_/y_<0.5 then
						    move_dir=5;
						elseif y_/x_<0.5 then
						    move_dir=7;
						else
						    move_dir=6;
						end;
					end;
					if xx<=0 and yy>=0 then
					    if x_/y_<0.5 then
						    move_dir=1;
						elseif y_/x_<0.5 then
						    move_dir=7;
						else
						    move_dir=8;
						end;
					end;
				end;
				-------------------------------------------------------------------------
		    end
			return true;
	    end; 
    end);

    --[[
	SP_button_giveup:setTouchEnabled(true);
    SP_button_giveup:addNodeEventListener(cc.NODE_TOUCH_EVENT,function ( event )
	    if scene_game_caser==3 then
	        GiveUp(3);
	    end;  
    end);
	]]--
    --【load】
    -----------------------永远可见
    --SP_background3:setVisible(true);
    ----------------------opencaser0
    --opencaser0();
    --【timer】
	local scheduler = cc.Director:getInstance():getScheduler();
    schedulerID=nil;--不可省略，如果省略会导致“停止”失效
    schedulerID = scheduler:scheduleScriptFunc(function()
	    casert=casert+1;
		if casert>10000000 then 
		    casert=1; 
		end;
		--【小车显示层初始化】begin
		SP_car1:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car1.png"));
		SP_car2:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("car2.png"));
		--【小车显示层初始化】end
		--【小车的生成】begin
		if car1_life<=0 and car2_life<=0 then
		    car1_life=100;
			car2_life=100;
			car1_midXmid=-1200;
			car2_midXmid=1200;
		end;
		--【小车的生成】end
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
	    --【小车的移动与生命】begin
		if car1_life>0 then
		    SP_car1:setVisible(true);
			SP_car1_life_:setVisible(true);
			SP_car1_life:setVisible(true);
		else
		    SP_car1:setVisible(false);
			SP_car1_life_:setVisible(false);
			SP_car1_life:setVisible(false);
		end;
		if car2_life>0 then
		    SP_car2:setVisible(true);
			SP_car2_life_:setVisible(true);
			SP_car2_life:setVisible(true);
		else
		    SP_car2:setVisible(false);
			SP_car2_life_:setVisible(false);
			SP_car2_life:setVisible(false);
		end;
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
	    --【小车的移动与生命】end
	    --【显示层的叠放层次控制(I与世界)】begin
		if I_midYmid+screenH/2-90>screenH/2-280 then--70为显示层人物高度。280为世界height的中间位置，也是防御塔和小兵的位置
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
		if u_midYmid+screenH/2-90>screenH/2-280 then--70为显示层人物高度。280为世界height的中间位置，也是防御塔和小兵的位置
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
	    --【方向控制begin】
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
	    if move_dir==1 then
		    if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+2; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_top=display.newAnimation(display.newFrames("%d-1.png",65+40,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_top,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_top,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==2 then
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+1.4;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+1.4; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+1.4; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+1.4; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_righttop=display.newAnimation(display.newFrames("%d-1.png",65+32,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_righttop,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_righttop,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==3 then
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+2;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_right=display.newAnimation(display.newFrames("%d-1.png",65+24,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_right,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_right,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==4 then
		    if I_midXmid<worldW/2 then
		        I_midXmid=I_midXmid+1.4;
			end;
			if I_midXmid<worldW/2-screenW/2 and I_midXmid>-(worldW/2-screenW/2) then
				camera_midXmid=camera_midXmid+1.4; 
			end;
			if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-1.4;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-1.4; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_rightdown=display.newAnimation(display.newFrames("%d-1.png",65+16,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_rightdown,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_rightdown,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==5 then
		    if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-2;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_down=display.newAnimation(display.newFrames("%d-1.png",65+8,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_down,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_down,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==6 then
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-1.4;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-1.4; 
			end;
			if I_midYmid>-(worldH/2-130) then
			    I_midYmid=I_midYmid-1.4;
			end;
			if I_midYmid>-(worldH/2-screenH/2) then
				camera_midYmid=camera_midYmid-1.4; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_leftdown=display.newAnimation(display.newFrames("%2d-1.png",65,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_leftdown,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_leftdown,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==7 then
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-2;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-2; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_left=display.newAnimation(display.newFrames("%d-1.png",65+56,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_left,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_left,false,function() ismoving=false; end,0);
			end;
		end;
		if move_dir==8 then
		    if I_midXmid>-(worldW/2) then
			    I_midXmid=I_midXmid-1.4;
			end;
			if I_midXmid>-(worldW/2-screenW/2) and I_midXmid<worldW/2-screenW/2 then
				camera_midXmid=camera_midXmid-1.4; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 then
			    I_midYmid=I_midYmid+1.4; 
			end;
			if I_midYmid<worldH/2-screenH/2-80 and I_midYmid>-(worldH/2-screenH/2) then
			    camera_midYmid=camera_midYmid+1.4; 
			end;
			SP_I_up:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_down:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid);
			SP_I_life_:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_I_life:align(display.CENTER, screenW/2+I_midXmid, screenH/2+I_midYmid+160);
			SP_attack1:align(display.CENTER, screenW/2+button_attack1_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack1_midYmid+camera_midYmid);
			SP_attack2:align(display.CENTER, screenW/2+button_attack2_midXmid+camera_midXmid, 
			                                   screenH/2+button_attack2_midYmid+camera_midYmid);
			SP_YaoGanBig:align(display.CENTER, screenW/2+button_move_midXmid+camera_midXmid, 
			                                   screenH/2+button_move_midYmid+camera_midYmid);
			SP_YaoGanSmall:align(display.CENTER, movepoint_x+camera_midXmid,movepoint_y+camera_midYmid);
			camera:setPositionX(camera_midXmid); 
	        camera:setPositionY(camera_midYmid);
			if ismoving==false then
			    ismoving=true;
			    local animation_XingZou_lefttop=display.newAnimation(display.newFrames("%d-1.png",65+48,8),0.02);--时间间隔0.2
			    SP_I_up:playAnimationOnce(animation_XingZou_lefttop,false,function() ismoving=false; end,0);
			    SP_I_down:playAnimationOnce(animation_XingZou_lefttop,false,function() ismoving=false; end,0);
			end;
		end;
		--【方向控制end】
		--【AI调整方向begin】
		if casert%50==0 then
		    u_move_dir=math.random(0,8);
		end;
		--【AI调整方向end】
		--【u的方向控制begin】
		if u_move_dir==1 then
		    if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+2; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
		        u_midXmid=u_midXmid+1.4;
			end;
			if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+1.4; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
		        u_midXmid=u_midXmid+2;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
		        u_midXmid=u_midXmid+1.4;
			end;
			if u_midYmid>-(worldH/2-130) then
			    u_midYmid=u_midYmid-1.4;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
			    u_midYmid=u_midYmid-2;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
			    u_midXmid=u_midXmid-1.4;
			end;
			if u_midYmid>-(worldH/2-130) then
			    u_midYmid=u_midYmid-1.4;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
			    u_midXmid=u_midXmid-2;
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
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
			    u_midXmid=u_midXmid-1.4;
			end;
			if u_midYmid<worldH/2-screenH/2-80 then
			    u_midYmid=u_midYmid+1.4; 
			end;
			SP_u_up1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_up2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down1:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_down2:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid);
			SP_u_life_:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			SP_u_life:align(display.CENTER, screenW/2+u_midXmid, screenH/2+u_midYmid+160);
			if u_ismoving==false then
			    u_ismoving=true;
			    local animation_XingZou_lefttop=display.newAnimation(display.newFrames("%d-1.png",65+48,8),0.02);--时间间隔0.2
			    SP_u_up1:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_up2:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_down1:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			    SP_u_down2:playAnimationOnce(animation_XingZou_lefttop,false,function() u_ismoving=false; end,0);
			end;
		end;
		--【u的方向控制end】
    end,0.01,false);
    --【function】
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
