package server;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Random;

import org.hibernate.Session;

import SQL_bean.Player;



public class ThreadTimer {
	private int RoomBegin=0;
	private int RoomEnd=0;
	private int ThreadTPS=BY.ThreadTPS;
	public ThreadTimer(int roombegin,int roomend){
		RoomBegin=roombegin;
		RoomEnd=roomend;
		new Thread(new Runnable() {
   			public void run() {
   				while(1==1){
   				try {Thread.sleep(1000/ThreadTPS);}catch (InterruptedException e){e.printStackTrace();}
   				for(int room=RoomBegin;room<=RoomEnd;room++)if(BY.roomperson[room]>=1){
   					if(BY.roomready[room]<=1){
            			BY.timer[room]=0;
            		}else{//��������׼�����˾Ϳ�ʼ��
            			//System.out.println("now,2 person ready ed.we begin!!!");
            			BY.timer[room]++;
            			//=================================================================================
            			//=================================================================================
            			//=================================================================================
            			//============��֡ͬ����=============================================================
            			//=================================================================================
            			if(BY.timer[room]%(ThreadTPS/ThreadTPS)==0)
            				WS.BigFPS_SameTime(room);
            			//=================================================================================
            			//=================================================================================
            			//=================================================================================
            			//============ÿ֡������=============================================================
            			//=================================================================================
            			System.out.println("car1 life="+BY.car_life[room][0]);
            			System.out.println("car2 life="+BY.car_life[room][1]);
            			//��С�������ɡ�begin
            			if( BY.car_life[room][0]<=0 && BY.car_life[room][1]<=0){ 
            				BY.car_life[room][0]=100;
            				BY.car_life[room][1]=100;
            				BY.car_midX[room][0]=-1200;
            				BY.car_midX[room][1]=1200;
            			}
            			//��С�������ɡ�end
            			//��С�����������begin
            			if (BY.car_life[room][0]>0 && BY.car_midX[room][0]>1000){
            				BY.tower_life[room][1]-=0.05;
            			}
            			if (BY.car_life[room][1]>0 && BY.car_midX[room][1]<-1000){
            				BY.tower_life[room][0]-=0.05;
            			}
            		    //��С�����������end
            		    //����������С����begin
            			if (BY.car_life[room][0]>0 && BY.car_midX[room][0]>400 ){
            				BY.car_life[room][0]-=0.05;
            			}
            			if (BY.car_life[room][1]>0 && BY.car_midX[room][1]<-400 ){
            				BY.car_life[room][1]-=0.05;
            			}
            		    //����������С����end
            			//����������Ӣ�ۡ�begin
            			if (BY.main_life[room][0]>0&&BY.main_midX[room][0]>400&&BY.main_midX[room][0]<400+325*5){
            				BY.main_life[room][0]-=0.05;
            			}
            			if (BY.main_life[room][1]>0&&BY.main_midX[room][1]<-400&&BY.main_midX[room][1]>-(400+325*5)){
            				BY.main_life[room][1]-=0.05;
            			}
            			//����������Ӣ�ۡ�end
            		    //��С����С����begin
            			if (BY.car_life[room][0]>0 && BY.car_life[room][1]>0 ){
            			    if (BY.car_midX[room][1]<90 && BY.car_midX[room][0]>-90 ){
            			    	BY.car_life[room][0]-=0.1;
            			    	BY.car_life[room][1]-=0.1;
            			    }
            			}
            		    //��С����С����end
            			//��С����visible�ı��֪ͨclient��begin
            			for(int car_who=0;car_who<=1;car_who++){
            				//��true
            				if(BY.car_life[room][car_who]>0){
                				if(BY.car_visible[room][car_who]==false){
                					BY.car_visible[room][car_who]=true;
                					WS.changed_car_visible(room, car_who, true);
                				}
                			}
            				//��false
            				if(BY.car_life[room][car_who]<=0){
                				if(BY.car_visible[room][car_who]==true){
                					BY.car_visible[room][car_who]=false;
                					WS.changed_car_visible(room, car_who, false);
                				}
                			}
            			}
            			//��С����visible�ı��֪ͨclient��end
            		    //��С�����ƶ���begin
            			if (BY.car_life[room][0]>0 ){
            				if ((BY.car_life[room][1]>0 && BY.car_midX[room][0]<-80)
            					||(BY.car_life[room][1]<=0 && BY.car_midX[room][0]<1050) ){
            					BY.car_midX[room][0]+=1;
            				}
            			}
            			if (BY.car_life[room][1]>0 ){
            				if ((BY.car_life[room][0]>0 && BY.car_midX[room][1]>80)
                					||(BY.car_life[room][0]<=0 && BY.car_midX[room][1]>-1050) ){
                					BY.car_midX[room][1]-=1;
                				}
            			}
            		    //��С�����ƶ���end
            			//������I��u��8�����ƶ�begin��
            			for(int dir_i=0;dir_i<=1;dir_i++){
            		    if (BY.move_direction[room][dir_i]==1 ){
            			    if (BY.main_midY[room][dir_i]<BY.worldH/2-BY.screenH/2-80){
            			    	BY.main_midY[room][dir_i]+=3; 
            			    }
            		    }
            		    if (BY.move_direction[room][dir_i]==2 ){
            			    if (BY.main_midX[room][dir_i]<BY.worldW/2 ){
            			    	BY.main_midX[room][dir_i]+=2;
            			    }
            				if (BY.main_midY[room][dir_i]<BY.worldH/2-BY.screenH/2-80){
            			    	BY.main_midY[room][dir_i]+=2; 
            			    }
            		    }
            			if (BY.move_direction[room][dir_i]==3 ){
            				if (BY.main_midX[room][dir_i]<BY.worldW/2 ){
            			    	BY.main_midX[room][dir_i]+=3;
            			    }
            			}
            			if (BY.move_direction[room][dir_i]==4 ){
            				if (BY.main_midX[room][dir_i]<BY.worldW/2 ){
            			    	BY.main_midX[room][dir_i]+=2;
            			    }
            				if (BY.main_midY[room][dir_i]>-(BY.worldH/2-130)){
            			    	BY.main_midY[room][dir_i]-=2; 
            			    }
            			}
            			if (BY.move_direction[room][dir_i]==5 ){
            				if (BY.main_midY[room][dir_i]>-(BY.worldH/2-130)){
            			    	BY.main_midY[room][dir_i]-=3; 
            			    }
            			}
            			if (BY.move_direction[room][dir_i]==6 ){
            			    if (BY.main_midX[room][dir_i]>-(BY.worldW/2)){ 
            			    	BY.main_midX[room][dir_i]-=2;
            			    }
            				if (BY.main_midY[room][dir_i]>-(BY.worldH/2-130)){
            			    	BY.main_midY[room][dir_i]-=2; 
            			    }
            			}
            			if (BY.move_direction[room][dir_i]==7 ){
            				if (BY.main_midX[room][dir_i]>-(BY.worldW/2)){ 
            			    	BY.main_midX[room][dir_i]-=3;
            			    }
            			}
            			if (BY.move_direction[room][dir_i]==8 ){
            				if (BY.main_midX[room][dir_i]>-(BY.worldW/2)){ 
            			    	BY.main_midX[room][dir_i]-=2;
            			    }
            				if (BY.main_midY[room][dir_i]<BY.worldH/2-BY.screenH/2-80){
            					BY.main_midY[room][dir_i]+=2; 
            				}
            		    }
            			}//for
            			//������I��u��8�����ƶ�end��
            			//=================================================================================
            			//=================================================================================
            			//=================================================================================
            			//===========ĳʱ�̴�����=============================================================
            			//=================================================================================
            			if(BY.timer[room]==1){//ͬʱ��������client��Timer
            				for(int sofa0=0;sofa0<=BY.sofasum-1;sofa0++)
           						if(BY.socket_link[room][sofa0]){
           							//BY.channel[room][sofa0].writeAndFlush(new TextmisWebSocketFrame("T"+BY.timer[room]+"}"));
           			        		//----------------------------------------------------
           			        		//����Ϣ����client
           			        		{
           			        			ByteBuf[] first = new ByteBuf[100000];
           			        			{
           			        	    	byte[] req2=("T"+BY.timer[room]+"}").getBytes();
           			        	    	first[0]=Unpooled.buffer(req2.length);
           			        	    	first[0].writeBytes(req2);

           			        	    	//  ����1/4
           			        	    	first[0].retain();//��������1
           			        	    	//  ����2/4
           			        	    	BY.channel[room][sofa0].writeAndFlush(first[0]);// ��������1��Ϊ��ֹ��0�޷����ʣ���Ҫ��ǰ��1
           			        	    	//System.out.println(first[0].refCnt());
           			        	    	//  ����3/4
           			        	    	first[0].release();
           			        	    	//  ����4/4
           			        	    	first[0]=null;
           			        			}
           			        		}
           			        		//----------------------------------------------------
           						}
            			}
                	    if(BY.timer[room]==31*ThreadTPS){//ʱ������0
                	    	//WS.toFirst(room);
                	    }
                	    if(BY.timer[room]==16*ThreadTPS){//��Ǯ�޸����ݿ�
                	    	for(int i=0;i<=BY.sofasum-1;i++)if(BY.readyed[room][i]){
                	    		/*
                	    		String redis_value=RedisClient.Find(""+BY.P_id[room][i]);
                	    		String[] values=redis_value.split("~");
                	    		values[2]=BY.P_money[room][i]+"";
                	    		redis_value=values[0]+"~"+values[1]+"~"+values[2]+"~"+values[3];
                	    	    RedisClient.AddOrUpdate(BY.P_id[room][i]+"", redis_value);
                	    	    */
                	    	/*
                	    	Session session = null;			
                			try {
                				session = HibernateInitialize.getSession();
                				Player p_ = (Player) session.load(Player.class, BY.P_id[room][i]);
                				p_.setMoney(BY.P_money[room][i]);
                				session.beginTransaction();//��������//�ύ��sql[1/3]
                				session.update(p_ );//�ύ��sql[2/3]
                				session.getTransaction().commit();//�ύ��sql[3/3]
                			} catch (Exception e) {
                				System.out.println("�����޸�ʧ��");
                				e.printStackTrace();
                			} finally{
                				HibernateInitialize.closeSession();//�ر�Session
                			}*/
                	    	}
                	    }
                	    if(BY.timer[room]==24*ThreadTPS){//֪ͨ�û��������µ�����
        	    			//for(int i=0;i<=4;i++)WS.changed_me_them_from(room,i);
                	    }
                	    //=================================================================================
            			//=================================================================================
            			//=================================================================================
            			//=================================================================================
            			//=================================================================================
            		}
   				}
   				}
   			}
   		}).start(); // �����߳�
	}
}
