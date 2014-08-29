#!/bin/bash

OLD_PANEL_POSITION=$(xfconf-query -c xfce4-panel -p /panels/panel-0/output-name)
case $OLD_PANEL_POSITION in
    VGA-0)
	NEW_PANEL_POSITION=LVDS-0;;
    LVDS-0)
	NEW_PANEL_POSITION=VGA-0;;
esac
xfconf-query -c xfce4-panel -p /panels/panel-0/output-name -s $NEW_PANEL_POSITION
