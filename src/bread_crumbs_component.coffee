defaultTemplate = """
{{#each crumb in breadCrumbs}}
<li {{bind-attr class="crumb.isCurrent:current:"}}>
  {{#if crumb.linkable}}
    {{#link-to crumb.path}}
      {{crumb.name}}
    {{/link-to}}
  {{else}}
    {{crumb.name}}
  {{/if}}
</li>
{{/each}}
"""

BreadCrumbs.BreadCrumbsComponent = Ember.Component.extend

  tagName: "ul"
  classNames: ["breadcrumbs"]

  layout: Ember.Handlebars.compile defaultTemplate

  router: null
  applicationController: null

  handlerInfos: (->
    handlerInfos = @get("router").router.currentHandlerInfos
  ).property "applicationController.currentPath"

  pathNames: (->
    @get("handlerInfos").map (handlerInfo) ->
      handlerInfo.name
  ).property "handlerInfos.[]"

  controllers: (->
    @get("handlerInfos").map (handlerInfo) ->
      handlerInfo.handler.controller
  ).property "handlerInfos.[]"

  breadCrumbs: (->
    controllers = @get "controllers"
    defaultPaths = @get "pathNames"

    breadCrumbs = []

    controllers.forEach (controller, index) ->
      crumbs = controller.get('breadCrumbs') || Ember.A([])
      singleCrumb = controller.get('breadCrumb')

      if (!Ember.isBlank(singleCrumb))
        crumbs.push
          name: singleCrumb
          path: controller.get("breadCrumbPath")
          model: controller.get("breadCrumbModel")


      crumbs.forEach (crumb) ->
        defaultPath = defaultPaths[index]
        breadCrumbs.addObject
          name: crumbName
          path: specifiedPath || defaultPath
          linkable: (specifiedPath != false)
          isCurrent: false

    deepestCrumb = breadCrumbs.get "lastObject"
    if deepestCrumb
      deepestCrumb.isCurrent = true

    breadCrumbs
  ).property "controllers.@each.breadCrumb", "controllers.@each.breadCrumbs", "controllers.@each.breadCrumbPath", "pathNames.[]"
