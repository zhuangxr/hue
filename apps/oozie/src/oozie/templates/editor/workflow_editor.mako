## Licensed to Cloudera, Inc. under one
## or more contributor license agreements.  See the NOTICE file
## distributed with this work for additional information
## regarding copyright ownership.  Cloudera, Inc. licenses this file
## to you under the Apache License, Version 2.0 (the
## "License"); you may not use this file except in compliance
## with the License.  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
<%!
from desktop.views import commonheader, commonfooter
from django.utils.translation import ugettext as _
%>

<%namespace name="dashboard" file="/common_dashboard.mako" />

${ commonheader(_("Workflow Editor"), "Oozie", user) | n,unicode }


<%dashboard:layout_toolbar>
  <%def name="widgets()">
    <div data-bind="css: { 'draggable-widget': true },
                    draggable: {data: draggableHiveAction(), isEnabled: true,
                    options: {'start': function(event, ui){lastWindowScrollPosition = $(window).scrollTop();$('.card-body').slideUp('fast');},
                              'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"
         title="${_('Hive Script')}" rel="tooltip" data-placement="top">
         <a class="draggable-icon"><img src="/oozie/static/art/icon_beeswax_48.png" class="app-icon"></a>
    </div>

    <div data-bind="css: { 'draggable-widget': true},
                    draggable: {data: draggablePigAction(), isEnabled: true,
                    options: {'start': function(event, ui){lastWindowScrollPosition = $(window).scrollTop();$('.card-body').slideUp('fast');},
                        'stop': function(event, ui){$('.card-body').slideDown('fast'); }}}"
         title="${_('Pig Script')}" rel="tooltip" data-placement="top">
         <a class="draggable-icon"><img src="/oozie/static/art/icon_pig_48.png" class="app-icon"></a>
    </div>

    <div data-bind="css: { 'draggable-widget': true },
                    draggable: {data: draggableJavaAction(), isEnabled: true,
                    options: {'start': function(event, ui){lastWindowScrollPosition = $(window).scrollTop();$('.card-body').slideUp('fast');},
                              'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"
         title="${_('Java program')}" rel="tooltip" data-placement="top">
         <a class="draggable-icon"><i class="fa fa-file-code-o"></i></a>
    </div>

    <div data-bind="css: { 'draggable-widget': true },
                    draggable: {data: draggableMapReduceAction(), isEnabled: true,
                    options: {'start': function(event, ui){lastWindowScrollPosition = $(window).scrollTop();$('.card-body').slideUp('fast');},
                              'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"
         title="${_('MapReduce job')}" rel="tooltip" data-placement="top">
         <a class="draggable-icon"><i class="fa fa-file-code-o"></i></a>
    </div>
</%def>
</%dashboard:layout_toolbar>


<div class="search-bar">
  <div class="pull-right" style="padding-right:50px">    
    <a title="${ _('Gen XML') }" rel="tooltip" data-placement="bottom" data-bind="click: gen_xml, css: {'btn': true}">
      <i class="fa fa-file-code-o"></i>
    </a>
    &nbsp;&nbsp;
    % if user.is_superuser:
      <a title="${ _('Edit') }" rel="tooltip" data-placement="bottom" data-bind="click: toggleEditing, css: {'btn': true, 'btn-inverse': isEditing}">
        <i class="fa fa-pencil"></i>
      </a>
      &nbsp;
      <button type="button" title="${ _('Settings') }" rel="tooltip" data-placement="bottom" data-toggle="modal" data-target="#settingsDemiModal" data-bind="css: {'btn': true}">
        <i class="fa fa-cog"></i>
      </button>
      <button type="button" title="${ _('Save') }" rel="tooltip" data-placement="bottom" data-loading-text="${ _("Saving...") }" data-bind="click: $root.save, css: {'btn': true}">
        <i class="fa fa-save"></i>
      </button>
      &nbsp;&nbsp;&nbsp;
      <a class="btn" href="${ url('oozie:new_workflow') }" title="${ _('New') }" rel="tooltip" data-placement="bottom" data-bind="css: {'btn': true}">
        <i class="fa fa-file-o"></i>
      </a>
    % endif
  </div>
</div>



 <div id="emptyDashboard" data-bind="fadeVisible: !isEditing() && columns().length == 0">
  <div style="float:left; padding-top: 90px; margin-right: 20px; text-align: center; width: 260px">${ _('Click on the pencil to get started with your dashboard!') }</div>
    <img src="/static/art/hint_arrow.png" />
  </div>

  <div id="emptyDashboardEditing" data-bind="fadeVisible: isEditing() && columns().length == 0 && previewColumns() == ''">
    <div style="float:right; padding-top: 90px; margin-left: 20px; text-align: center; width: 260px">${ _('Pick an index and Click on a layout to start your dashboard!') }</div>
    <img src="/static/art/hint_arrow_horiz_flipped.png" />
  </div>


  <div data-bind="visible: isEditing() && previewColumns() != '' && columns().length == 0, css:{'with-top-margin': isEditing()}">
  <div class="container-fluid">
    <div class="row-fluid" data-bind="visible: previewColumns() == 'oneSixthLeft'">
      <div class="span2 preview-row"></div>
      <div class="span10 preview-row"></div>
    </div>
    <div class="row-fluid" data-bind="visible: previewColumns() == 'full'">
      <div class="span12 preview-row">
      </div>
    </div>
    <div class="row-fluid" data-bind="visible: previewColumns() == 'magic'">
      <div class="span12 preview-row">
        <div style="text-align: center; color:#EEE; font-size: 180px; margin-top: 80px">
          <i class="fa fa-magic"></i>
        </div>
      </div>
    </div>
  </div>
</div>

<div data-bind="css: {'dashboard': true, 'with-top-margin': isEditing()}">
  <div class="container-fluid">
    <div class="row-fluid" data-bind="template: { name: 'column-template', foreach: columns}">
    </div>
    <div class="clearfix"></div>
  </div>
</div>

<script type="text/html" id="column-template">
  <div data-bind="css: klass">
##
##    <div class="container-fluid">
##      <div class="row-fluid">
##        <div class="span12" data-bind="click: function(){$data.addEmptyRow(true)}, css: {'dropTarget': true, 'is-editing': $root.isEditing}, sortable: { data: drops, isEnabled: $root.isEditing, 'afterMove': function(event){var widget=event.item; var _r = $data.addEmptyRow(true); _r.addWidget(widget);$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)}); columnDropAdditionalHandler(widget)}, options: {'placeholder': 'dropTargetHighlight', 'greedy': true, 'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"></div>
##      </div>
##      <div class="row-fluid">
##        <div class="span1">W</div>
##        <div class="span10" data-bind="template: { name: 'row-template', foreach: rows}"></div>
##        <div class="span1">E</div>
##      </div>
##      <div class="row-fluid">
##        <div class="span12" data-bind="click: function(){$data.addEmptyRow()}, css: {'dropTarget': true, 'is-editing': $root.isEditing}, sortable: { data: drops, isEnabled: $root.isEditing, 'afterMove': function(event){var widget=event.item; var _r = $data.addEmptyRow(); _r.addWidget(widget);$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)}); columnDropAdditionalHandler(widget)}, options: {'placeholder': 'dropTargetHighlight', 'greedy': true, 'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"></div>
##      </div>
##    </div>

    <div class="container-fluid" data-bind="visible: $root.isEditing()">
      <div data-bind="click: function(){$data.addEmptyRow(true)}, css: {'dropTarget': true, 'is-editing': $root.isEditing}, sortable: { data: drops, isEnabled: $root.isEditing, 'afterMove': function(event){var widget=event.item; var _r = $data.addEmptyRow(true); _r.addWidget(widget);$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)}); columnDropAdditionalHandler(widget)}, options: {'placeholder': 'dropTargetHighlight', 'greedy': true, 'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"></div>
    </div>
    <div data-bind="template: { name: 'row-template', foreach: rows}">
    </div>
    <div class="container-fluid" data-bind="visible: $root.isEditing() && (rows().length > 0 ||  $root.isNested())">
      <div data-bind="click: function(){$data.addEmptyRow()}, css: {'dropTarget': true, 'is-editing': $root.isEditing}, sortable: { data: drops, isEnabled: $root.isEditing, 'afterMove': function(event){var widget=event.item; var _r = $data.addEmptyRow(); _r.addWidget(widget);$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)}); columnDropAdditionalHandler(widget)}, options: {'placeholder': 'dropTargetHighlight', 'greedy': true, 'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});}}}"></div>
    </div>
  </div>
</script>

<script type="text/html" id="row-template">
  <div class="emptyRow" data-bind="visible: widgets().length == 0 && $index() == 0 && $root.isEditing() && $parent.size() > 4 && $parent.rows().length == 1 && ! $root.isNested">
    <img src="/static/art/hint_arrow_flipped.png" style="float:left; margin-right: 10px"/>
    <div style="float:left; text-align: center; width: 260px">${_('Drag any of the widgets inside your empty row')}</div>
    <div class="clearfix"></div>
  </div>

  <div class="container-fluid">
    <div class="row-fluid">
      <div class="span1 pointer">
        <div data-bind="css: {'dropTarget': true, 'is-editing': $root.isEditing}, droppable: {enabled: $root.isEditing, onDrop: function(){ console.log('dropped'); $data.addEmptyColumn(); } }"></div>
      </div>
      <div class="span10">


      <div data-bind="visible: columns().length == 0, style: { 'border-bottom': $root.isNested() ? 'none' : '' }, css: {'row-fluid': true, 'row-container':true, 'is-editing': $root.isEditing},
        sortable: { template: 'widget-template', data: widgets, allowDrop: $root.isEditing() && (! $root.isNested() || ($root.isNested() && widgets().length < 1)), isEnabled: $root.isEditing() && (! $root.isNested() || ($root.isNested() && widgets().length < 1)),
        options: {'handle': '.move-widget', 'opacity': 0.7, 'placeholder': 'row-highlight', 'greedy': true,
            'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});},
            'helper': function(event){lastWindowScrollPosition = $(window).scrollTop(); $('.card-body').slideUp('fast'); var _par = $('<div>');_par.addClass('card card-widget');var _title = $('<h2>');_title.addClass('card-heading simple');_title.text($(event.toElement).text());_title.appendTo(_par);_par.height(80);_par.width(180);return _par;}},
            dragged: function(widget){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});widgetDraggedAdditionalHandler(widget)}}">
    </div>
    <div class="container-fluid" data-bind="visible: $root.isNested() && columns().length > 0" style="border: 1px solid #e5e5e5; border-top: none; background-color: #F3F3F3;">
      <div data-bind="css: {'row-fluid': true, 'row-container':true, 'is-editing': $root.isEditing}">
        <div data-bind="template: { name: 'column-template', foreach: columns}">
        </div>
      </div>
    </div>




      </div>
      <div class="span1">
        <div data-bind="css: {'dropTarget': true, 'is-editing': $root.isEditing}, droppable: {enabled: $root.isEditing, onDrop: function(){ console.log('dropped'); $data.addEmptyColumn(); } }"></div>
      </div>
    </div>
  </div>

##  <div class="container-fluid">
##    <div class="row-header" data-bind="visible: $root.isEditing">
##      <span class="muted">${_('Row')}</span>
##      <div style="display: inline; margin-left: 60px">
##        <a href="javascript:void(0)" data-bind="visible: $root.isNested, click: function(){ $data.addEmptyColumn(); }"><i class="fa fa-columns"></i></a>
##        <a href="javascript:void(0)" data-bind="visible: $index()<$parent.rows().length-1, click: function(){moveDown($parent, this)}"><i class="fa fa-chevron-down"></i></a>
##        <a href="javascript:void(0)" data-bind="visible: $index()>0, click: function(){moveUp($parent, this)}"><i class="fa fa-chevron-up"></i></a>
##        <a href="javascript:void(0)" data-bind="visible: $parent.rows().length > 1, click: function(){remove($parent, this)}"><i class="fa fa-times"></i></a>
##      </div>
##    </div>
##    <div data-bind="visible: columns().length == 0, style: { 'border-bottom': $root.isNested() ? 'none' : '' }, css: {'row-fluid': true, 'row-container':true, 'is-editing': $root.isEditing},
##        sortable: { template: 'widget-template', data: widgets, allowDrop: $root.isEditing() && (! $root.isNested() || ($root.isNested() && widgets().length < 1)), isEnabled: $root.isEditing() && (! $root.isNested() || ($root.isNested() && widgets().length < 1)),
##        options: {'handle': '.move-widget', 'opacity': 0.7, 'placeholder': 'row-highlight', 'greedy': true,
##            'stop': function(event, ui){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});},
##            'helper': function(event){lastWindowScrollPosition = $(window).scrollTop(); $('.card-body').slideUp('fast'); var _par = $('<div>');_par.addClass('card card-widget');var _title = $('<h2>');_title.addClass('card-heading simple');_title.text($(event.toElement).text());_title.appendTo(_par);_par.height(80);_par.width(180);return _par;}},
##            dragged: function(widget){$('.card-body').slideDown('fast', function(){$(window).scrollTop(lastWindowScrollPosition)});widgetDraggedAdditionalHandler(widget)}}">
##    </div>
##    <div class="container-fluid" data-bind="visible: $root.isNested() && columns().length > 0" style="border: 1px solid #e5e5e5; border-top: none; background-color: #F3F3F3;">
##      <div data-bind="css: {'row-fluid': true, 'row-container':true, 'is-editing': $root.isEditing}">
##        <div data-bind="template: { name: 'column-template', foreach: columns}">
##        </div>
##      </div>
##    </div>
##  </div>
</script>

<script type="text/html" id="widget-template">
  <div data-bind="attr: {'id': 'wdg_'+ id(),}, css: klass">
    <h2 class="card-heading simple">
      <span data-bind="visible: $root.isEditing">
        <a href="javascript:void(0)" class="move-widget"><i class="fa fa-arrows"></i></a>
        <a href="javascript:void(0)" data-bind="click: compress, visible: size() > 1"><i class="fa fa-step-backward"></i></a>
        <a href="javascript:void(0)" data-bind="click: expand, visible: size() < 12"><i class="fa fa-step-forward"></i></a>
        &nbsp;
      </span>
      <!-- ko if: $root.collection && $root.collection.getFacetById(id()) -->
      <span data-bind="with: $root.collection.getFacetById(id())">
        <span data-bind="editable: label, editableOptions: {enabled: $root.isEditing(), placement: 'right'}"></span>
      </span>
      <!-- /ko -->
      <!-- ko if: typeof $root.collection == 'undefined' || $root.collection.getFacetById(id()) == null -->
        <span data-bind="editable: name, editableOptions: {enabled: $root.isEditing(), placement: 'right'}"></span>
      <!-- /ko -->
      <div class="inline pull-right" data-bind="visible: $root.isEditing">
        <a href="javascript:void(0)" data-bind="click: $root.removeWidget"><i class="fa fa-times"></i></a>
      </div>
    </h2>
    <div class="card-body" style="padding: 5px;">
      <div data-bind="template: { name: function() { return widgetType(); }}" class="widget-main-section"></div>
    </div>
  </div>
</script>










<script type="text/html" id="start-widget">
  <!-- ko if: $root.workflow.getNodeById(id()) -->
  <div class="row-fluid" data-bind="with: $root.workflow.getNodeById(id())">
    <div data-bind="visible: $root.isEditing" style="margin-bottom: 20px">
      <input type="text" data-bind="value: id" />
      <input type="text" data-bind="value: name" />
    </div>

    <div>
      Start
    </div>
  </div>
  <!-- /ko -->
</script>


<script type="text/html" id="end-widget">
  <!-- ko if: $root.workflow.getNodeById(id()) -->
  <div class="row-fluid" data-bind="with: $root.workflow.getNodeById(id())">
    <div data-bind="visible: $root.isEditing" style="margin-bottom: 20px">
      <input type="text" data-bind="value: id" />
      <input type="text" data-bind="value: name" />
    </div>

    <div>
      End
    </div>
  </div>
  <!-- /ko -->
</script>


<script type="text/html" id="hive-widget">
  <!-- ko if: $root.workflow.getNodeById(id()) -->
  <div class="row-fluid" data-bind="with: $root.workflow.getNodeById(id())">
    <div data-bind="visible: $root.isEditing" style="margin-bottom: 20px">
      <input type="text" data-bind="value: id" />
      <input type="text" data-bind="value: name" />
    </div>

    <div>
      <ul class="nav nav-tabs">
        <li class="active"><a href="#action" data-toggle="tab">${ _('Hive') }</a></li>
        <li><a href="#files" data-toggle="tab">${ _('Files') }</a></li>
        <li><a href="#sla" data-toggle="tab">${ _('SLA') }</a></li>
        <li><a href="#credentials" data-toggle="tab">${ _('Credentials') }</a></li>
        <li><a href="#transitions" data-toggle="tab">${ _('Transitions') }</a></li>
      </ul>
      <div class="tab-content">
        <div class="tab-pane active" id="action">
          <img src="/oozie/static/art/icon_beeswax_48.png" class="app-icon">
        </div>
        <div class="tab-pane" id="files">
        </div>
        <div class="tab-pane" id="sla">
        </div>
        <div class="tab-pane" id="credentials">
        </div>
        <div class="tab-pane" id="transitions">
          OK --> []
          KO --> []
        </div>
      </div>
    </div>
  </div>
  <!-- /ko -->
</script>


<script type="text/html" id="pig-widget">
  <!-- ko if: $root.workflow.getNodeById(id()) -->
  <div class="row-fluid" data-bind="with: $root.workflow.getNodeById(id())">
    <div data-bind="visible: $root.isEditing" style="margin-bottom: 20px">
      <input type="text" data-bind="value: id" />
      <input type="text" data-bind="value: name" />
    </div>

    <div>
      <ul class="nav nav-tabs">
        <li class="active"><a href="#action" data-toggle="tab">${ _('Pig') }</a></li>
        <li><a href="#files" data-toggle="tab">${ _('Files') }</a></li>
        <li><a href="#sla" data-toggle="tab">${ _('SLA') }</a></li>
        <li><a href="#credentials" data-toggle="tab">${ _('Credentials') }</a></li>
        <li><a href="#transitions" data-toggle="tab">${ _('Transitions') }</a></li>
      </ul>
      <div class="tab-content">
        <div class="tab-pane active" id="action">
          <img src="/oozie/static/art/icon_pig_48.png" class="app-icon">
        </div>
        <div class="tab-pane" id="files">
        </div>
        <div class="tab-pane" id="sla">
        </div>
        <div class="tab-pane" id="credentials">
        </div>
        <div class="tab-pane" id="transitions">
          OK --> []
          KO --> []
        </div>
      </div>
    </div>
  </div>
  <!-- /ko -->
</script>


<link rel="stylesheet" href="/oozie/static/css/workflow-editor.css">
<link rel="stylesheet" href="/static/ext/css/hue-filetypes.css">
<link rel="stylesheet" href="/static/ext/css/hue-charts.css">
<link rel="stylesheet" href="/static/ext/chosen/chosen.min.css">


${ dashboard.import_layout() }

<script src="/static/ext/js/bootstrap-editable.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/js/hue.utils.js"></script>
<script src="/static/js/ko.editable.js" type="text/javascript" charset="utf-8"></script>
<script src="/static/ext/chosen/chosen.jquery.min.js" type="text/javascript" charset="utf-8"></script>

${ dashboard.import_bindings() }

<script src="/oozie/static/js/workflow-editor.ko.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">
  var viewModel = new WorkflowEditorViewModel(${ layout_json | n,unicode }, ${ workflow_json | n,unicode });
  ko.applyBindings(viewModel);

  viewModel.init();
  fullLayout(viewModel);

  function columnDropAdditionalHandler(widget) {
    widgetDraggedAdditionalHandler(widget);
  }

  function widgetDraggedAdditionalHandler(widget) {
    viewModel.workflow.addNode(widget);
  }
</script>

${ commonfooter(messages) | n,unicode }
