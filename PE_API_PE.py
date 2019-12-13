# -*- coding: utf-8 -*-
"""
Created on Sun Nov  4 14:19:31 2018

@author: Daniel Campoy

The API call was based on Doug Fraser code example for using the HSP API he
posted on blackboard hsp_api_example.py (National Rail HSP data) 
"""
import requests
import json
import stationNamesCodes as sc
from datetime import date
import time
from datetime import timedelta
from datetime import datetime
from sklearn import preprocessing as prp
from sklearn.neighbors import KNeighborsClassifier as kn

class Hsp:
    #Format for call the Service Metrics API
    """json_input_sm = {'from_loc':'NRW',
                     'to_loc':'LST',
                     'from_time':'0600',
                     'to_time':'1500',
                     'from_date':'2018-09-01',
                     'to_date':'2018-11-06',
                     'days':'WEEKDAY'
                     }
    """
    #Format for calling the Service Deails API
    """json_input_dm ={'rid': '201607023389301'}"""
    #start and stop is for tracking performance information
    def __init__(self):
        Hsp.start = 0.0
        Hsp.stop = 0.0
        Hsp. n = 0 
        Hsp.i = 0    
    
        Hsp.json_exception =''
        # Service Metrics API used to gather the list of rids between stations
        Hsp.array_sm =[]
        
        #this is used to store the rids that will be passed to the Service Details API
        Hsp.array_rid = []
        #Lists below are used for gathering historic train delay from API 
        Hsp.actual_timearrival = []
        Hsp.actual_timedepart = []
        Hsp.predicte_arrival = []
        Hsp.predicte_departure = []
        Hsp.day_of_week = []
        Hsp.platform_delay = ''
        #These three are for gathering data of the when the train has arrived at the final destination 
        # and its shortcode
        Hsp.final_dest = ''
        Hsp.dest_timearrival = []
        Hsp.travel_time_dest = []
            
        #Lists of delay information gathering for kNN predication and length of delay in minutes
        Hsp.hour_departure =[]
        Hsp.depart_delta = []
        Hsp.arrival_delta = []
        Hsp.travel_day = []
        Hsp.train_time_delay = 0

    
    
    
    # Function passing the platform of customer, destination, train delay time, and top of hour
    def train_delayed (self, from_loc, to_loc, train_time_delay,hour = datetime.now().time().strftime('%H%M')):
        from_loc = sc.station_shortcode(from_loc)
        to_loc = sc.station_shortcode(to_loc)
        orgin = sc.station_name(from_loc)
        dest = sc.station_name(to_loc)
        Hsp.train_time_delay = train_time_delay
        Hsp.final_dest = to_loc
        cvrt = time.strptime(hour,'%H%M')
        top_hour = float(time.strftime('%H', cvrt))
        
        print ('Building Service Metric API. \n','From: ',orgin,'Station \n To: ',dest,'Station')
        print ('......')
        print ('.......')
        print ('........')
        print ('Hour of Departure :',top_hour)
        print ('Current train delay in minutes: ',Hsp.train_time_delay)
        Hsp.start = time.perf_counter()
        return Hsp.SM_api(from_loc,to_loc)
    
    
    def SM_api_all (self, from_loc, to_loc, from_time, to_time, from_date, to_date, days):
        self.from_loc = from_loc
        self.to_loc = to_loc
        self.from_time = from_time
        self.to_time = to_time
        self.from_date = from_date
        self.to_date = to_date
        self.days = days
        Hsp.platform_delay = from_loc
        #Cleans the list to subumit a new request to the SM api
        if len(Hsp.array_sm) > 1:
            Hsp.array_sm.clear()
            
        array = [self.from_loc, self.to_loc, self.from_time, self.to_time, self.from_date, self.to_date, self.days]
        
        Hsp.array_sm.extend(array)
        
        print ('Calling Srevice Metric API.')
        print ('......')
        print ('.......')
        print ('........')
        return Hsp.service_metric_api(self)
        """
        The SM_api function will only accept a to and from location for a
        request delay the from _time will take the current time of the request,
        to_time is set to 23:59 as 00:00 is considered next day,
        and the delay_date will take todays date to determine the range of rids
        it will request.
        """
        #This function will be used to determine the to_date and days parameters based upon the current date
    @classmethod 
    def SM_api(self, from_loc, to_loc, from_time = datetime.now().time().strftime('%H%M'), to_time = '2359', delay_date=date.today()):
        #from_time = datetime.now().time().strftime('%H%M'),
        self.from_loc = from_loc
        self.to_loc = to_loc
        self.from_time = from_time
        self.to_time = to_time
        to_date = date.strftime(delay_date,'%Y-%m-%d')
        Hsp.platform_delay = from_loc
        #this from_time is used to get the current time when the SM_api function is called
        #from_time = datetime.now().time().strftime('%H%M')
        """
        These if and else statements are determining the day of the week 
        and supply the correct parameter into the SM API call. Additionally
        determine the from_date if it is a weekday then pull the last 100 days
        if it is a weekend then pull the last 200 days
        0 = Monday - 6 = Sunday
        """
        if delay_date.weekday() >= 0 and delay_date.weekday() <=4:
            days = 'WEEKDAY'
            #wk is the how far to set the date from the current day
            wk = timedelta(days=100)
            from_date = date.strftime((delay_date - wk),'%Y-%m-%d')
        elif (delay_date.weekday() == 5):
            days = 'SATURDAY'
            #wk is the how far to set the date from the current day
            wk = timedelta(days=200)
            #print (wk)
            from_date = date.strftime((delay_date - wk),'%Y-%m-%d')
        else:
            days = 'SUNDAY'
            wk = timedelta(days=200)
            from_date = date.strftime((delay_date - wk),'%Y-%m-%d')
        #Cleans the list to subumit a new request to the SM api
        if len(Hsp.array_sm) > 1:
            Hsp.array_sm.clear()
            
        array = [self.from_loc, self.to_loc, self.from_time, self.to_time, from_date, to_date, days]
        Hsp.array_sm.extend(array) 
        print ('Calling Srevice Metric API.')
        print ('......')
        print ('.......')
        print ('........')
        return Hsp.service_metric_api(self)
          
    def prnt (self):
        #print('Testing method ',self.from_loc, self.to_loc, self.from_time, self.to_time, self.from_date, self.to_date, self.days,'')
        print(Hsp.array_sm)
        
        """self is connecting to the Service Metrics API"""
    def service_metric_api (self):
        self.url_sm ='https://hsp-prod.rockshore.net/api/v1/serviceMetrics'
        self.header = { 'Content-Type': 'application/json' }
        self.login = ('d.campoy@uea.ac.uk','Shiny2001!') 
        self.json_pass_sm = { 'from_loc': Hsp.array_sm[0],
                'to_loc': Hsp.array_sm[1],
                'from_time': Hsp.array_sm[2],
                'to_time': Hsp.array_sm[3],
                'from_date': Hsp.array_sm[4],
                'to_date': Hsp.array_sm[5],
                'days':Hsp.array_sm[6]                    
                }
        #using a try except block to return any JSON Requests messages outside of a 200 code
        try:
            self.response_sm = requests.post(self.url_sm,headers=self.header,auth=self.login,json=self.json_pass_sm)
        except Exception as e:
            Hsp.json_exception = e
        #These two lines of code were used for testing and troubleshooting issues for example
        # finding out that some of the fields were blank
        #the response_sm in the next line was used for testing this call within the Console
        #response_sm = requests.post('https://hsp-prod.rockshore.net/api/v1/serviceMetrics',headers={'Content-Type': 'application/json'} ,auth=('d.campoy@uea.ac.uk','Shiny2001!'),json=Hsp.json_pass_sm)
        
        #Cleans the list to to populate it with a new set of rids
        if len(Hsp.array_rid) > 1:
            Hsp.array_rid.clear()
        
        sm_call_response = json.loads(self.response_sm.text)
        #the print below is used to troublshoot the api call to find any errors
        #print('response is {}'.format(sm_call_response))
        
        #for loop to go through the list of lists in Services key to append 
        # the rids into array_rid that will be used to gather departure and arrival times
        for sam,rids in enumerate(sm_call_response['Services']):
            Hsp.array_rid.extend(sm_call_response['Services'][sam]['serviceAttributesMetrics']['rids'])
        
        #print(json.dumps(json.loads(self.response_sm.text), sort_keys=True, indent=2, separators=(',',': ')))
        print ('Connecting to Service Detail API for rids.')
        print ('......')
        print ('.......')
        print ('........')
        return Hsp.populate(),Hsp.json_exception
        
        """ service_detail_api supplys a rid to this function will make a call 
            to the api to return trian arrival times based upon the rid and 
            location of the platform the user is on
        """
    def service_detail_api (rid):
        url_sd = 'https://hsp-prod.rockshore.net/api/v1/serviceDetails'
        header = { 'Content-Type': 'application/json' }
        login = ('d.campoy@uea.ac.uk','Shiny2001!')
        json_pass_sd = {'rid':rid}#201811217681100 rid used for testing
        try:
            response_sd = requests.post(url_sd,headers=header,auth=login,json=json_pass_sd)
            #response_sd = requests.post('https://hsp-prod.rockshore.net/api/v1/serviceDetails',headers={ 'Content-Type': 'application/json' },auth=('d.campoy@uea.ac.uk','Shiny2001!'),json={'rid':201812287853789})
            sd_call_response = json.loads(response_sd.text)
        except Exception as e:
            Hsp.json_exception
        
        srvdate = datetime.strptime(sd_call_response['serviceAttributesDetails']['date_of_service'],'%Y-%m-%d')
        
        #Monday is 0 and 6 is Sunday
        #builds a list of the days of the week for each rids service date
        
        if srvdate.weekday() == 0:
            Hsp.day_of_week.append('Monday')
        elif srvdate.weekday() == 1:
            Hsp.day_of_week.append('Tuesday')
        elif srvdate.weekday() == 2:
            Hsp.day_of_week.append('Wednesday')
        elif srvdate.weekday() == 3:
            Hsp.day_of_week.append('Thursday')
        elif srvdate.weekday() == 4:
            Hsp.day_of_week.append('Friday')
        elif srvdate.weekday() == 5:
            Hsp.day_of_week.append('Saturday')
        else:
            Hsp.day_of_week.append('Sunday')
            


        for sdm,loc in enumerate(sd_call_response['serviceAttributesDetails']['locations']):

            #these were used to test what the output looks like            
            #print ('sdm output: ',sdm)
            #print ('loc output: ',loc)
            #print (loc['gbtt_pta'])
            #print ('Line output: ',sd_call_response['serviceAttributesDetails']['locations'][sdm])
            
            #Gathering the time arrival of the final destination
            if Hsp.final_dest == loc['location']:
                
                if (loc['actual_ta'] == ''):
                    Hsp.dest_timearrival.append(loc['gbtt_pta'])
                else:
                    Hsp.dest_timearrival.append(loc['actual_ta'])
            
            #Gather the times for the platform with the delay
            if Hsp.platform_delay == loc['location']:

                '''
                    If a the station has a train starting from it that is witin
                    a defined train line ie Norwich to London for example at 
                    IPswitch station there are trains that start here and 
                    goes to London. 
                    The different if statements has to fix the nosiey data which
                    contained missing information. 
                '''

                #print (loc['location'])
                # for the below if rid 201810097681283 showed only gbtt_ptd in its fields
                if (loc['gbtt_pta'] == '') & (loc['actual_td'] == '') & (loc['actual_ta'] == ''):                
                    Hsp.predicte_arrival.append(loc['gbtt_ptd'])
                    Hsp.actual_timearrival.append(loc['gbtt_ptd'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['gbtt_ptd'])
                #this is if a train is cancled the JSON will not have actual 
                # times for departure and arrival
                elif (loc['actual_td'] == '') & (loc['actual_ta'] == ''):
                    Hsp.predicte_arrival.append(loc['gbtt_pta'])
                    Hsp.actual_timearrival.append(loc['gbtt_pta'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['gbtt_ptd'])
                #This elif is to handle data from a train that starts from this station
                elif (loc['gbtt_pta'] == '') & (loc['actual_ta'] == ''):
                    Hsp.predicte_arrival.append(loc['gbtt_ptd'])
                    Hsp.actual_timearrival.append(loc['actual_td'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['actual_td'])
                elif(loc['actual_td'] == ''):#This is to handle of the train was canceled from this station
                    Hsp.predicte_arrival.append(loc['gbtt_pta'])
                    Hsp.actual_timearrival.append(loc['actual_ta'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['gbtt_ptd'])
                elif(loc['actual_ta'] == ''):#This is to handle of the train was canceled from this station
                    Hsp.predicte_arrival.append(loc['gbtt_pta'])
                    Hsp.actual_timearrival.append(loc['gbtt_pta'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['actual_td'])
                elif(loc['gbtt_pta'] == ''):#This is to handle of the train was canceled from this station
                    Hsp.predicte_arrival.append(loc['actual_ta'])
                    Hsp.actual_timearrival.append(loc['actual_ta'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['actual_td'])
                elif(loc['gbtt_ptd'] == ''):#This is to handle of the train was canceled from this station
                    Hsp.predicte_arrival.append(loc['gbtt_pta'])
                    Hsp.actual_timearrival.append(loc['actual_ta'])
                    Hsp.predicte_departure.append(loc['actual_td'])
                    Hsp.actual_timedepart.append(loc['actual_td'])
                else:
                    Hsp.predicte_arrival.append(loc['gbtt_pta'])
                    Hsp.actual_timearrival.append(loc['actual_ta'])
                    Hsp.predicte_departure.append(loc['gbtt_ptd'])
                    Hsp.actual_timedepart.append(loc['actual_td'])
            #print ('n vlaue',Hsp.n)
            #print ('i vlaue',Hsp.i)
        
        '''
        This block of code performs the creation of kNN vectors for arrival
        deltas, hour of departure, departure deltas and day of travel the data 
        point is only stored if both the arrival and departure have a delay and that day of 
        the delay is capture
        '''
        service_day = Hsp.day_of_week[-1]
        #Creating the delay times in total seconds then divide by 60 to show in minutes
        # negative numbers are showing the train arrving early and are negagted from 
        # the final list as well as trains on time ie diff is 0
        
        t1 = time.strptime(Hsp.predicte_arrival[-1],'%H%M')
        t1d = timedelta(hours=t1.tm_hour, minutes=t1.tm_min)
        t2 = time.strptime(Hsp.actual_timearrival[-1],'%H%M')
        t2d = timedelta(hours=t2.tm_hour, minutes=t2.tm_min)
        
        hour = Hsp.actual_timedepart[-1]
        cvrt = time.strptime(hour,'%H%M')
        time_hr = float(time.strftime('%H', cvrt))
        #Creating the delay times in total seconds then divide by 60 to show in minutes
        # negative numbers are showing the train departing early and are negagted from 
        # the final list as well as trains on time ie diff is 0
        t3 = time.strptime(Hsp.predicte_departure[-1],'%H%M')
        t3d = timedelta(hours=t3.tm_hour, minutes=t3.tm_min)
        t4 = time.strptime(Hsp.actual_timedepart[-1],'%H%M')
        t4d = timedelta(hours=t4.tm_hour, minutes=t4.tm_min)
    
        total_dprt = t4d - t3d

        total_arv = t2d - t1d
        
        arv_delay_min = total_arv.total_seconds()/60
        dprt_delay_min = total_dprt.total_seconds()/60
        
        #print('time1',t1,'/n','timedelta',t1d,'/n','time2',t2,'/n','timedelta2',t2d)
        #print(delay_min)
        if arv_delay_min >= 1.0 and dprt_delay_min >=1.0:
            Hsp.arrival_delta.append(arv_delay_min)
            Hsp.travel_day.append(service_day)
            Hsp.depart_delta.append(dprt_delay_min)
            Hsp.hour_departure.append(time_hr)
            #print(Hsp.arrival_delta)
        Hsp.i +=1
        Hsp.n +=1
    
           
        

        #This print is used to find blank data populated in the departure and arrival data
        #print(arrival_time,n)
        return Hsp.json_exception
    
    #populate function will loop through the array_rid and call the service_detail_api
    # to gather all station information from the rids and normalize data

    def populate ():
        print('Populating historical time data and normalizing')
        pss = 0
        x = 0
        rid = 0
        #print(len(Hsp.depart_delta))
        try:
            while (len(Hsp.depart_delta) <= 50 and len(Hsp.arrival_delta) <= 50):
                #print ('Number of data points ' , len(Hsp.depart_delta))
                rid_pass = Hsp.array_rid[x]
                #print ('Rid passed ',rid_pass)
                #print ('Number of rids passed ' , x)
                #for rid_pass in Hsp.array_rid:
                rid = rid_pass
                pss+=1
                x +=1
                #print('Array length ',len(Hsp.depart_delta))
                Hsp.service_detail_api(rid)
            print (pss,'rids passed::::: to Service Detail API')
            print ('\n')
            print (pss,'pass::::','rid to sd api',rid_pass)
        except:
            return Hsp.default_prediction()
        
        return Hsp.calculate()
    #This function creates the vector for when the final train will arrive
    def calculate():
        print ('Creating final destination time feature for kNN vectors')
        print ('++++++')
        print ('+++++++')
        print ('++++++++')
        y = 0
        for prdprt in Hsp.predicte_departure:
            dest_time = Hsp.dest_timearrival[y]
            #print ('dest_time ', dest_time)
            t2 = time.strptime(Hsp.actual_timedepart[y],'%H%M')
            t2d = timedelta(hours=t2.tm_hour, minutes=t2.tm_min)
            t3 = time.strptime(dest_time,'%H%M')
            t3d = timedelta(hours=t3.tm_hour, minutes=t3.tm_min)
            dest_total = t3d - t2d
            #print('dest _total', dest_total)
            arrival_time = dest_total.total_seconds()/60
            #print('arrival_time')
            if arrival_time >= 1.0:
                Hsp.travel_time_dest.append(arrival_time)
            y += 1
        

        return Hsp.knn_build()
    
    def default_prediction():
        print ('Not enought data points and calculating a default prediction')
        y = 0
        avg = 0
        for prdprt in Hsp.predicte_departure:
            dest_time = Hsp.dest_timearrival[y]
            #print ('dest_time ', dest_time)
            t2 = time.strptime(Hsp.actual_timedepart[y],'%H%M')
            t2d = timedelta(hours=t2.tm_hour, minutes=t2.tm_min)
            t3 = time.strptime(dest_time,'%H%M')
            t3d = timedelta(hours=t3.tm_hour, minutes=t3.tm_min)
            dest_total = t3d - t2d
            #print('dest _total', dest_total)
            arrival_time = dest_total.total_seconds()/60
            #print('arrival_time')
            if arrival_time >= 1.0:
                Hsp.travel_time_dest.append(arrival_time)
            y += 1

        for i in Hsp.travel_time_dest:
            avg += i 
                
        travel = round(avg/len(Hsp.travel_time_dest),0)
        
        to_dest_add = timedelta(minutes=travel)
        prd_time_add = timedelta(minutes=Hsp.train_time_delay)
        current_time = datetime.now().time().strftime('%H%M')
        time_cvrt = time.strptime(current_time,'%H%M')
        current_time_add = timedelta(hours=time_cvrt.tm_hour, minutes=time_cvrt.tm_min)
        
        arrive = current_time_add + prd_time_add + to_dest_add
        Hsp.stop = time.perf_counter()
        
        return int(Hsp.train_time_delay), str(arrive)

    def knn_build():
        print('Calculating when the train will arrive.')

        lble = prp.LabelEncoder()
        day_encoded = lble.fit_transform(Hsp.travel_day)
        #using the arrival minutes delta as its label of prediction to determine
        # when the train will arrive on their platform
        label = Hsp.arrival_delta
        features = list(zip(Hsp.depart_delta,day_encoded,Hsp.hour_departure))
        
        model = kn(n_neighbors=3)
        model.fit(features,label)
        
        hour = datetime.now().time().strftime('%H%M')
        cvrt = time.strptime(hour,'%H%M')
        top_hr = float(time.strftime('%H', cvrt))
        
        delay_day=date.today().weekday()
        
        predicted = model.predict([[Hsp.train_time_delay,delay_day,top_hr]])
        
        avg = 0
        for i in Hsp.travel_time_dest:
            avg += i 
                
        travel = round(avg/len(Hsp.travel_time_dest),0)
        
        to_dest_add = timedelta(minutes=travel)
        prd_time = time.strptime(str(int(predicted)),'%M')
        prd_time_add = timedelta(minutes=prd_time.tm_min)
        current_time = datetime.now().time().strftime('%H%M')
        time_cvrt = time.strptime(current_time,'%H%M')
        current_time_add = timedelta(hours=time_cvrt.tm_hour, minutes=time_cvrt.tm_min)
        
        arrive = current_time_add + prd_time_add + to_dest_add
        
        Hsp.stop = time.perf_counter()
        
        #print('Predicted time of delay is: ', int(predicted), 'minutes','\n',
        #            'Your train will arrive in ',sc.station_name(Hsp.array_sm[1]),' Station at', str(arrive))
        return int(predicted), str(arrive)
    
       
        
def ReturnDelay(from_loc, to_loc, delaymins):
    h = Hsp()
    delay=  h.train_delayed(from_loc, to_loc, delaymins)
    return 'Your train will be delayed by {} minutes, and should arrive at {}.'.format(delay[0][0], delay[0][1])

if __name__ == '__main__':
    #h = Hsp()
   
    r = ReturnDelay('gatwick airport', 'peterborough', 25.0)
    print("Returns: {}".format(r))
    print (Hsp.stop - Hsp.start)
    s = ReturnDelay('norwich','london liverpool street',10.0)
    print("Returns: {}".format(s))
    print (Hsp.stop - Hsp.start)
    t = ReturnDelay('MANCHESTER OXFORD ROAD','norwich',15.0)
    print("Returns: {}".format(t))
    print (Hsp.stop - Hsp.start)
    l = ReturnDelay('York','Plymouth',20.0)
    print("Returns: {}".format(l))
    print (Hsp.stop - Hsp.start)
    
#Testing the Sm_api function if I only pass the to and from loc parameters
#test_api = Hsp()
#manchester to liverpool has been known to have delays and used for testing
#test_api.station_codes('MANCHESTER OXFORD ROAD','LIVERPOOL LIME STREET')
#test_api.train_delayed('MANCHESTER PICCADILLY','London Euston',20.0)
#print(Hsp.array_sm)
#test_api.service_metric_api()
#print (test_api.array_rid)

#test_api.populate()
#    print ('predictied arrival: ',Hsp.predicte_arrival)
#    print ('actual arrival: ',Hsp.actual_timearrival)
#    print ('predicted depart: ',Hsp.predicte_departure)
#    print ('actual depart: ',Hsp.actual_timedepart)
#    print ('Days of service: ', Hsp.day_of_week)
#    
##test_api.calculate()
#    print ('Arrival Delay: ',Hsp.arrival_delta)
#    print ('Departure Delay: ',Hsp.depart_delta)
#    print ('Hour of Departure Delay: ', Hsp.hour_departure)
#    print ('Day of Delay: ', Hsp.travel_day)
##print ('Knn Hist Data: ',knn_hist_data)
#    print('Run Time: ', Hsp.stop - Hsp.start)
##Testing Weekend times 
#test_weknd = Hsp()
#test_weknd.SM_api_all('NRW','LST','0600','1600','2018-03-01','2018-12-22','SATURDAY')
#print ('Arrival Delay: ',Hsp.arrival_delta)
#print ('Departure Delay: ',Hsp.depart_delta)
#print ('Hour of Departure Delay: ', Hsp.hour_departure)
#print ('Day of Delay: ', Hsp.travel_day)


#Returns 40 rids from the return with this test making sure I pass the correct number of rids
#test_call = Hsp()
#test_call.SM_api_all('NRW','LST','0600','1500','2018-10-01','2018-10-02','WEEKDAY')
#test_api.SM_api('NRW','LST')
#test_api.SM_api_all('IPS','LST','1200','2100','2018-10-01','2018-10-10','WEEKDAY')
