# Orca::Constants.pm: Global constants for Orca.
#
# Copyright (C) 1998-2001 Blair Zajac and Yahoo!, Inc.

package Orca::Constants;

use strict;
use Exporter;
use vars qw(@EXPORT_OK @ISA $VERSION);
@ISA     = qw(Exporter);
$VERSION = substr q$Revision: 0.01 $, 10;

# ORCA_VERSION		This version of Orca.
# ORCA_RRD_VERSION	This is the version number used in creating the DS
#			names in RRDs.  This should be updated any time a
#			new version of Orca needs some new content in its
#			RRD files.  The DS name is a concatentation of the
#			string Orca with this string of digits.
# DAY_SECONDS		The number of seconds in one day.
# IS_WIN32		If Orca is running on a Windows platform.
use vars         qw($ORCA_VERSION $ORCA_RRD_VERSION);
push(@EXPORT_OK, qw($ORCA_VERSION $ORCA_RRD_VERSION DAY_SECONDS IS_WIN32));
$ORCA_VERSION        =  '0.264';
$ORCA_RRD_VERSION    =  19990222;
sub DAY_SECONDS      () { 24*60*60 };
sub IS_WIN32         () { $^O eq 'MSWin32' };

# These define the name of the different round robin archives (RRAs)
# to create in each RRD file, how many primary data points go into a
# consolidated data point, and how far back in time they go.
#
# The first RRA is every 5 minutes for 200 hours, the second is every
# 30 minutes for 31 days, the third is every 2 hours for 100 days, and
# the last is every day for 3 years.
#
# The first array holds the names of the different RRAs and is also
# used in the list of plots to create.  The second array holds the
# number of 300 second intervals are used to create a consolidated
# data point.  The third array is the number of consolidated data
# points held in the RRA.
use vars         qw(@RRA_PLOT_TYPES @RRA_PDP_COUNTS @RRA_ROW_COUNTS);
push(@EXPORT_OK, qw(@RRA_PLOT_TYPES @RRA_PDP_COUNTS @RRA_ROW_COUNTS));
BEGIN {
  @RRA_PLOT_TYPES = qw(daily weekly monthly yearly);
  @RRA_PDP_COUNTS =   (    1,     6,     24,   288);
  @RRA_ROW_COUNTS =   ( 2400,  1488,   1200,  1098);
}

# Define all of the different possible plots to create.  This
# structure allows the user via the configuration file to turn off
# particular plots to create, such the monthly one.  In addition to
# the plot types that are structured in the RRD via its RRA's, there
# is an additional hourly plot that is listed before the daily plot
# and an additional quarterly plot (100 days) created between the
# monthly and yearly plots.  The quarterly plot is updated daily.
#
# For each plot type, the first value in the array reference is the
# number of 300 second intervals are used in a plot.  The second value
# is the number of seconds graphed in the plots.  Be careful to not
# increase the time interval so much that the number of data points to
# plot are greater than the number of pixels available for the image,
# otherwise there will be a 30% slowdown due to a reduction
# calculation to resample the data to the lower resolution for the
# plot.  For example, with 40 days of 2 hour data, there are 480 data
# points.  For no slowdown to occur, the image should be at least 481
# pixels wide.
#
# The @CONST_IMAGE_PLOT_TYPES variable contains the order in which
# plots are created and all of the elements of
# @CONST_IMAGE_PLOT_TITLES should appear as keys in
# @CONST_IMAGE_PLOT_INFO.
use vars         qw(@CONST_IMAGE_PLOT_TYPES %CONST_IMAGE_PLOT_INFO);
push(@EXPORT_OK, qw(@CONST_IMAGE_PLOT_TYPES %CONST_IMAGE_PLOT_INFO));
BEGIN {
  @CONST_IMAGE_PLOT_TYPES = qw(hourly daily weekly monthly quarterly yearly);
  %CONST_IMAGE_PLOT_INFO   =
  ('hourly'    => [$RRA_PDP_COUNTS[0],   1.5*60*60],        #  18 data points
   'daily'     => [$RRA_PDP_COUNTS[0],   1.5*DAY_SECONDS],  # 432 data points
   'weekly'    => [$RRA_PDP_COUNTS[1],  10  *DAY_SECONDS],  # 480 data points
   'monthly'   => [$RRA_PDP_COUNTS[2],  40  *DAY_SECONDS],  # 480 data points
   'quarterly' => [$RRA_PDP_COUNTS[3], 100  *DAY_SECONDS],  # 100 data points
   'yearly'    => [$RRA_PDP_COUNTS[3], 428  *DAY_SECONDS]); # 428 data points

  # Ensure that the number of elements of @CONST_IMAGE_PLOT_TYPES
  # exactly matches the keys of %CONST_IMAGE_PLOT_INFO.
  unless (@CONST_IMAGE_PLOT_TYPES == keys %CONST_IMAGE_PLOT_INFO) {
      die "$0: internal error: number of elements in ",
          "\@CONST_IMAGE_PLOT_TYPES does not match number of keys in ",
          "\%CONST_IMAGE_PLOT_INFO.\n";
  }

  foreach my $title (@CONST_IMAGE_PLOT_TYPES) {
    unless (defined $CONST_IMAGE_PLOT_INFO{$title}) {
      die "$0: internal error: element `$title' in ",
          "\@CONST_IMAGE_PLOT_TYPES is not a key in ",
          "\%CONST_IMAGE_PLOT_INFO.\n";
    }
  }
}

# These variables hold copies of @CONST_IMAGE_PLOT_TYPES and
# @CONST_IMAGE_PLOT_INFO with only those plot types that are specified
# in the configuration file.
use vars         qw(@IMAGE_PLOT_TYPES @IMAGE_PDP_COUNTS @IMAGE_TIME_SPAN);
push(@EXPORT_OK, qw(@IMAGE_PLOT_TYPES @IMAGE_PDP_COUNTS @IMAGE_TIME_SPAN));

# This holds the length of the longest plot type string that is
# specified in the configuration file.
use vars         qw($MAX_PLOT_TYPE_LENGTH);
push(@EXPORT_OK, qw($MAX_PLOT_TYPE_LENGTH));

# These variables are set once at program start depending upon the
# command line arguments:
# $opt_daemon			Daemonize Orca.
# $opt_generate_gifs		Generate GIFs instead of PNGs.
# $opt_log_filename		Output log filename.
# $opt_once_only		Do only one pass through Orca.
# $opt_no_html			Do not generate any HTML files.
# $opt_no_images		Do not generate any image files.
# $opt_verbose			Be verbose about my running.
use vars         qw($opt_daemon
                    $opt_generate_gifs
                    $opt_log_filename
                    $opt_no_html
                    $opt_no_images
                    $opt_once_only
                    $opt_verbose
                    $IMAGE_SUFFIX);
push(@EXPORT_OK, qw($opt_daemon
                    $opt_generate_gifs
                    $opt_log_filename
                    $opt_no_html
                    $opt_no_images
                    $opt_once_only
                    $opt_verbose
                    $IMAGE_SUFFIX));
$opt_daemon          = 0;
$opt_generate_gifs   = 0;
$opt_log_filename    = '';
$opt_no_html         = 0;
$opt_no_images       = 0;
$opt_once_only       = 0;
$opt_verbose         = 0;
$IMAGE_SUFFIX        = 'png';

# This constant stores the commonly used string to indicate that a
# subroutine has been passed an incorrect number of arguments.
use vars qw($INCORRECT_NUMBER_OF_ARGS);
push(@EXPORT_OK, qw($INCORRECT_NUMBER_OF_ARGS));
$INCORRECT_NUMBER_OF_ARGS = "passed incorrect number of arguments.\n";

# This subroutine is compiled once to prevent compiling of the
# subroutine sub { die $_[0] } every time an eval block is entered.
sub die_when_called {
  die $_[0];
}
push(@EXPORT_OK, qw(die_when_called));

# This contains the regular expression string to check if a string
# contains the "sub {" and "}" portions or this should be added.
use vars         qw($is_sub_re);
push(@EXPORT_OK, qw($is_sub_re));
$is_sub_re = '^\s*sub\s*{.*}\s*$';

1;