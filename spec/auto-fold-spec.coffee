AutoFold = require '../lib/auto-fold'

describe "AutoFold", ->
  describe "when the auto-fold:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.auto-fold')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'auto-fold:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.auto-fold')).toExist()

        autoFoldElement = workspaceElement.querySelector('.auto-fold')
        expect(autoFoldElement).toExist()

        autoFoldPanel = atom.workspace.panelForItem(autoFoldElement)
        expect(autoFoldPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'auto-fold:toggle'
        expect(autoFoldPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.auto-fold')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'auto-fold:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        autoFoldElement = workspaceElement.querySelector('.auto-fold')
        expect(autoFoldElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'auto-fold:toggle'
        expect(autoFoldElement).not.toBeVisible()
