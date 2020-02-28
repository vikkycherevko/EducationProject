/**
 * Created by TetianaSakun on 19.06.2019.
 */

({
    openWindow: function (component, helper, event) {
        component.set('v.isOpen', true);
    },
    closeWindow: function (component, helper, event) {
        component.set('v.isOpen', false);
        component.getEvent('updateDesk1').fire();
        },
});