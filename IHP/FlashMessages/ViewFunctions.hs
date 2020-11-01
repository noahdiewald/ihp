{-|
Module: IHP.FlashMessages.ViewFunctions
Description: Success and error messages for your application
Copyright: (c) digitally induced GmbH, 2020
-}
module IHP.FlashMessages.ViewFunctions where

import IHP.Prelude
import IHP.FlashMessages.Types
import IHP.Controller.RequestContext
import IHP.Controller.Session
import qualified Data.Maybe as Maybe
import qualified IHP.FrameworkConfig as FrameworkConfig
import qualified Text.Blaze.Html5 as Html5
import IHP.ViewSupport
import IHP.View.Types


-- | Displays the flash messages for the current request.
--
-- You can add a flash message to the next request by calling 'IHP.FlashMessages.ControllerFunctions.setSuccessMessage' or 'IHP.FlashMessages.ControllerFunctions.setErrorMessage':
--
-- > action CreateProjectAction = do
-- >     ...
-- >     setSuccessMessage "Your project has been created successfully"
-- >     redirectTo ShowProjectAction { .. }
--
--
-- > action CreateTeamAction = do
-- >     unless userOnPaidPlan do
-- >         setErrorMessage "This requires you to be on the paid plan"
-- >         redirectTo NewTeamAction
-- >
-- >     ...
--
-- For success messages, the text message is wrapped in a @<div class="alert alert-success">...</div>@, which is automatically styled by bootstrap.
-- Errors flash messages are wraped in @<div class="alert alert-danger">...</div>@.
renderFlashMessages :: forall context. (?context :: context, HasField "flashMessages" context [FlashMessage], FrameworkConfig.ConfigProvider context) => Html5.Html
renderFlashMessages = render flashMessages
    where
        flashMessages :: [FlashMessage]
        flashMessages = getField @"flashMessages" ?context

        render :: [FlashMessage] -> Html5.Html
        render = fromCSSFramework #styledFlashMessages