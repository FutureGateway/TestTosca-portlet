<%@ include file="/init.jsp" %>

        <script type="text/javascript">
                Liferay.Service(
        		  '/iam.token/get-token',
        		  function(obj) {
        		    token = obj;
        		  }
        		);
            /*
             * All the web app needs to configure are the following
             */
            var webapp_settings = {
                apiserver_proto: 'http'
               ,apiserver_host : 'localhost'
               ,apiserver_port : '8888'
               ,apiserver_path : ''
               ,apiserver_ver  : 'v1.0'
               ,username       : 'brunor'
               ,app_id         : 1               
            };
            /* Settings for sgw.indigo-datacloud.eu
            var webapp_settings = {
                apiserver_proto: 'https'
               ,apiserver_host : 'sgw.indigo-datacloud.eu'
               ,apiserver_port : '443'
               ,apiserver_path : '/apis'
               ,apiserver_ver  : 'v1.0'
               ,username       : 'brunor'
               ,app_id         : 1
            };
            */
            /*
             * Change variable below to change delay of check status loop
             */
            var TimerDelay = 15000;

            /*
             * Page initialization
             */
            $(document).ready(function() {
                $('#confirmDelete').on('show.bs.modal', function (e) {
                    $message = $(e.relatedTarget).attr('data-message');
                    $(this).find('.modal-body p').text($message);
                    $title = $(e.relatedTarget).attr('data-title');
                    $job_id = $(e.relatedTarget).attr('data-data');
                    $(this).find('.modal-title').text($title);
                    $('#job_id').attr('data-value', $job_id)
                    $('#confirmJobDel').show();
                    $('#cancelJobDel').text('Cancel')
                });
                // Form confirm (yes/ok) handler, submits form 
                $('#confirmDelete').find('.modal-footer #confirmJobDel').on('click', function(e){
                    $job_id = $('#job_id').attr('data-value');
                    cleanJob($job_id);              
                });
                prepareJobTable();                 // Fills the job table
                setTimeout(checkJobs, TimerDelay); // Initialize the job check loop
            });     
        </script>
        <div class="panel panel-default">
        <div class="panel-heading"><h3>Tester web application </h3></div>
        <div class="panel-body"> 
            <p>This is the simplest application
                 making use of FutureGateway REST APIs.</p>
        <button type="button" class="btn btn-primary btn-lg" id="openmodal" onClick="openModal()">
            Launch TOSCA test job
        </button>
        <hr>
        <!-- Submit record table (begin) -->    
        <div id="jobsDiv" data-modify="false"> 
        </div>        
        
        <!-- Submit record table (end) -->
        </div>        
        </div> 
        <div class="panel-footer"></div>
        <!-- Modal (begin) -->
        <div class="modal fade  modal-hidden" id="helloTesterModal" tabindex="-1" role="dialog" aria-labelledby="HelloTester">          
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">Hello tester submission pane</h4>
              </div>
              <div class="modal-body">
                <p>Welcome to the 1st web application testing the new FutureGateway APIs.</p>
                <p>This application just execute over SSH a simple hostname command.</p>
                <p>Please press <b>'submit'</b> button to execute the 'Hello' application.</p>
                <p>Press cancel to return to the Hello' home/summary page.</p>
                <p><b>Specify your job identifier: </b>
                <input type="text" id="jobDescription" size="60"/>
                </p>
                <!-- This is not shown properly
                <div class="modal-content" id="modal-content">                                                                               
                </div>
                -->
              </div>
              <div class="modal-footer">
                <center>                
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onClick="submitJob()" id="submitButton">Submit</button>
                </center>
              </div>
            </div>
          </div>
        </div>   
        <!-- Modal (end) -->
        <!-- Confirm Modal Dialog (begin) -->                       
        <div class="modal fade modal-hidden" id="confirmDelete" role="dialog" aria-labelledby="confirmDeleteLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Delete Parmanently</h4>
              </div>
              <div class="modal-body">
                  <p></p>
              </div>                
                <div id="job_id" class='job_id' data-name='job_id' data-value=''/>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal" id="cancelJobDel">Cancel</button>
                  <button type="button" class="btn btn-danger" id="confirmJobDel">Delete</button>
                  </div>
              </div>
            </div>
          </div>
        </div>