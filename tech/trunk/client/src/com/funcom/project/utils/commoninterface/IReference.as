package com.funcom.project.utils.commoninterface
{
    /**
     * Used to aid with objects whose usage needs to be tracked so that unused instances can be cleaned
     * up by the objects or their controllers.
     *
     * Any class that requires a reference count and functionality similar to reference counting should
     * implement this interface.
     */
    public interface IReference
    {
        /**
         * The current reference count
         */
        function get useCount():uint;

        /**
         * Increments the internal useCount value.
         */
        function addReference():void;

        /**
         * Releases the internal reference, decrementing the useCount value.
         */
        function releaseReference():void;
    }
}
