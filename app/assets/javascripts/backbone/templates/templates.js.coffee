PopHealth.Templates["selector"] = _.template "
  <label class=\"checkbox\">
      <input name=\"measure_id\" type=\"checkbox\" <% if (selected) { %> checked=\"checked\" <% } %> > <%= filter.get('name') %>
  </label>
"
PopHealth.Templates['demographics'] = _.template "
    <a class=\"dropdown-toggle\"
       data-toggle=\"dropdown\"
       href=\"#\">
        <%= label %>
        <b class=\"caret\"></b>
      </a>
    <ul class=\"dropdown-menu\">
    </ul>
"

PopHealth.Templates["measure"] = _.template "
  <div class=\"span4\">
    <% if (measure.get('sub_id') == null || measure.get('sub_id') === 'a') { %>
      <%= measure.get('name') %>
    <% } %>
  </div>
  <div class=\"span2\">
    <%= measure.get('short_subtitle') %>
  </div>
  <div class=\"span2\">
    <h4>45%</h4>
  </div>
  <div class=\"span1\">
    <div class=\"inline-fraction\">
      <span class=\"numeratorValue\">5</span>
      <span class=\"separator\"></span>
      <span class=\"denominatorValue\">10</span>
    </div>
  </div>
  <div class=\"span1\">
  </div>
"