/*global $, ajaxCall, moment, _ */
function initializeCalendar() {
  var initRoleFilter = $('#roles-filter').val();
  ajaxCall('/tasks.json', 'GET', 'JSON', { roleId: initRoleFilter },
    function successFn(data) {
      $('.loading-spinner-div').addClass('hidden');
      var tasks = processTasks(data);
      //insert tasks in table below
      insertTasksInTable(tasks[1]);
      $('#calendar').fullCalendar({
        lang: 'en',
        header: { left:'',center:'',right:'' }, // Display nothing at the top
        events: tasks[0],
        height: 650, // Fix height
        columnFormat: 'dddd', // Display just full length of weekday, without dates 
        defaultView: 'agendaWeek', // display week view
        hiddenDays: [], // hide Saturday and Sunday
        weekNumbers:  false, // don't show week numbers
        slotDuration: '00:15:00', // 15 minutes for each row
        allDaySlot: true, // show "all day" at the top
        firstDay: 1,
        allDayText: 'Any time'
      });
      if (tasks[0].length) { 
        $('.calendar-container').css('display', 'block'); 
      } else {
        $('.calendar-container').css('display', 'none'); 
        $('.no-tasks-message').css('display', 'block'); 
      }
    }, 
    function errorFn(err) {
      console.log(err);
  });
  
  $('#roles-filter').change(function() {
    var newRoleFilter = $('#roles-filter').val();
    getEventsOnRoleChange(newRoleFilter)
  });
}

function getEventsOnRoleChange(roleId) {
  var spinner = $('.loading-spinner-div');
  var noTasksMessage = $('.no-tasks-message');
  noTasksMessage.css('display', 'none');
  spinner.removeClass('hidden');
  
  ajaxCall('/tasks.json', 'GET', 'JSON', { roleId: roleId },
    function successFn(data) {
      spinner.addClass('hidden');
      var tasks = processTasks(data);
      var calendarContainer = $('.calendar-container');
      
      if (tasks[0].length) {
        calendarContainer.css('display', 'block');
        $('#calendar').fullCalendar('removeEvents');
        $("#calendar").fullCalendar('addEventSource', tasks[0]);
      } else {
        calendarContainer.css('display', 'none');
      }
      
      if (!tasks[0].length && !tasks[1].length) {
        noTasksMessage.css('display', 'block');
      }
      
      //insert tasks in table above
      insertTasksInTable(tasks[1]);
    }, 
    function errorFn(err) {
      console.log(err);
  });
}

function processTasks(data) {
  var ret = [];
  var calendarTasks = [];
  var listTasks = [];
  data.forEach(function(task) {
    var t = {
      id: task.id,
      className:'event-task-elem', 
      allDay: !task.mark_start, 
      title: task.name, 
      url: task.url, 
      backgroundColor: task.color, 
      borderColor: task.color, 
      task_type: task.task_type,
      mark_start: task.mark_start,
      start: task.start,
      end: task.end
    };

    if (task.day_of_week == -1) {
      if (!_.contains(_.pluck(listTasks, 'id'), t.id)) {
        listTasks.push(t);
      }
    } else {
      calendarTasks.push(t);
    }
  });
  ret.push(calendarTasks);
  ret.push(listTasks);
  return ret;
}

function insertTasksInTable(tasks) {
  var markup = '';
  var tasksListContainer = $('.any-day-tasks');
  var tasksList = $('.todo-list');
  tasksList.html('');
  
  if (!tasks.length) {
    tasksListContainer.css('display', 'none')
  } else {
    tasksListContainer.css('display', 'block')
  }
  
  _.each(tasks, function(t) {
    var time = t.mark_start ? formatTime(new Date(t.start)) + '-' + formatTime(new Date(t.end)) + ' ' : 'ANY TIME ';
    markup += `
      <li class="col-md-4">
        <span class="handle">
          <i class="fa fa-ellipsis-v"></i>
          <i class="fa fa-ellipsis-v"></i>
        </span>
        <span class="text">
          <span class="fc-event-dot" style="background-color:{3};width:30px"></span>
          <a href="{4}">{2}</a>
        </span> - {0}({1})
      </li>
    `
    .format([
        time,
        t.task_type.toUpperCase(), 
        t.title,
        t.backgroundColor,
        t.url
      ]);
  });
  tasksList.append(markup);
}

function checkTime(i) { return  i < 10 ? "0" + i : i; }

function formatTime(date) {
  var h = date.getHours() - 1;
  var m = date.getMinutes();
  h = checkTime(h);
  m = checkTime(m);
  return h + ':' + m;
}

function initializeFormActions() {
  $('#task_mark_start').change(function(e) {
    $('.scheduled-time-div').toggle();
    if(e.target.checked) {
      $('.scheduled-time-div').css('display', 'inline-block');
    }
  });
}