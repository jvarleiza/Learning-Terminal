/*global $, Option, contains, _, ajaxCall*/
var form = {};
function initFormsFunctionality(urlPathname) {
    var roleForm = $('.edit-new-entity-form');
    var eType = setEntityType(urlPathname);
    
    form = {
        roles: { hidden: $('[name="rel_roles_ids"]'), multi: $('#roles_rel_multiselect') },
        processes: { hidden: $('[name="rel_processes_ids"]'), multi: $('#processes_rel_multiselect') },
        tasks: { hidden: $('[name="rel_tasks_ids"]'), multi: $('#tasks_rel_multiselect') },
        
        departments: { hidden: $('#' + eType + '_departments'), multi: $('#departments_multiselect') },
        countries: { hidden: $('#' + eType + '_countries'), multi: $('#countries_multiselect') },
        business_units: { hidden: $('#' + eType + '_building_types'), multi: $('#business_units_multiselect') },
        
        linksModal: { hidden: $('#' + eType + '_related_links'), name: $('.link-name-value'), url: $('.link-url-value') },
        linksAttachment: { hidden: $('#' + eType + '_related_attachments'), name: $('.link-name-value-attachment'), url: $('.link-url-value-attachment') }
    };
    
    // Click action when adding a related link to the entity
    $('.add-link-from-modal-btn').click(function(e) {
        var name = form.linksModal.name.val();
        var url = form.linksModal.url.val();
        var newValue = form.linksModal.hidden.val() ? form.linksModal.hidden.val() + '@@' + name + "##" + url : name + "##" + url;
        form.linksModal.hidden.val(newValue);
        
        var markup = '<tr>'+
        '<td class="name-of-related-link"><a target="_blank" href="'+url+'">'+name+'</a></td>' +
        '<td><a onclick="deleteLinkFn()" href="#"><i class="fa fa-trash-o related-link-trash"></i></a></td></tr>';
        $("#links-table tbody").append(markup);
        $('.related-link-trash').click(deleteLinkFn);
        form.linksModal.name.val('');
        form.linksModal.url.val('');
        $('#related-links-modal').modal('toggle');
    });
    
    // Click action when the trash is pressed to eliminate a related link
    $('.related-link-trash').click(deleteLinkFn);
    
    initializeForm(form, eType);
    
    roleForm.submit(function onRoleSubmit(event) {
        event.preventDefault();
        
        var deptValues = form.departments.multi.val();
        var countValues = form.countries.multi.val().join('@@');
        var bussValues = form.business_units.multi.val().join('@@');
        
        var rolesRelValues = form.roles.multi.val();
        var processesRelValues = form.processes.multi.val();
        var tasksRelValues = form.tasks.multi.val();
        
        form.departments.hidden.val(deptValues);
        form.countries.hidden.val(countValues);
        form.business_units.hidden.val(bussValues);

        if (rolesRelValues && processesRelValues && tasksRelValues) {
            form.roles.hidden.val(rolesRelValues.join('@@'));
            form.processes.hidden.val(processesRelValues.join('@@'));
            form.tasks.hidden.val(tasksRelValues.join('@@'));
        }
        $(this).unbind('submit').submit();
    });
    
    form.departments.multi.change(function() {
        changeInDepartmentDropdown();
    });
}

function initializeForm(form, eType) {
    var isNewForm = !!$('#new_' + eType).length;
    if (!isNewForm) {
        form.departments.multi.val(form.departments.hidden.val().split('@@')).change();
        form.countries.multi.val(form.countries.hidden.val().split('@@')).change();
        form.business_units.multi.val(form.business_units.hidden.val().split('@@')).change();
        
        var roles = form.roles.hidden.val();
        var processes = form.processes.hidden.val();
        var tasks = form.tasks.hidden.val();
        
        if(roles) { form.roles.multi.val(roles.split('@@')) }
        if(processes) { form.processes.multi.val(processes.split('@@')) }
        if(tasks) { form.tasks.multi.val(tasks.split('@@')) }
    }
}

function setEntityType(url) {
    var ret;
    if (contains(url, '/roles/')) {
        ret = 'role';
    } else if (contains(url, '/process_lts/')) {
        ret = 'process_lt';
    } else if (contains(url, '/tasks/')) {
        ret = 'task';
    } else if (contains(url, '/quality_tips/')) {
        ret = 'quality_tip';
    }
    return ret;
}

function deleteLinkFn(e) {
    e.stopPropagation();
    e.preventDefault();
    var row = $(this).closest('tr').find('.name-of-related-link');
    var nameUrl = row.text().trim() + '##' + $(row.html()).attr('href').trim();
    var actualLinks = form.linksModal.hidden.val();
    var newLinks = _.filter(actualLinks.split('@@'), function(link) { return link !== nameUrl }).join('@@');
    form.linksModal.hidden.val(newLinks);
    $(this).closest('tr').remove();
}


function changeInDepartmentDropdown() {
    form.roles.multi.empty();
    form.processes.multi.empty();
    form.tasks.multi.empty();
    
    makeAjaxCallForDepChange('/roles_form', form.roles.multi);
    makeAjaxCallForDepChange('/processes_form', form.processes.multi);
    makeAjaxCallForDepChange('/tasks_form', form.tasks.multi);
}

function makeAjaxCallForDepChange(url, multi) {
    var deptSelected = form.departments.multi.val();
    var entityId = $('#entity-id').val();
    var locale = $('.locale-select select').val();
    ajaxCall(url, 'GET', 'JSON', { dept: deptSelected, e_id: entityId, loc: locale }, function(data) {
        multi.select2({
            placeholder: 'Select...', 
            data: _.map(data, function(d) {
                return { text: d.name, id: d.id }
            })
        });
    }, function(){});
}
