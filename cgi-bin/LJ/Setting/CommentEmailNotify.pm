# This code was forked from the LiveJournal project owned and operated
# by Live Journal, Inc. The code has been modified and expanded by
# Dreamwidth Studios, LLC. These files were originally licensed under
# the terms of the license supplied by Live Journal, Inc, which can
# currently be found at:
#
# http://code.livejournal.org/trac/livejournal/browser/trunk/LICENSE-LiveJournal.txt
#
# In accordance with the original license, this code and all its
# modifications are provided under the GNU General Public License.
# A copy of that license can be found in the LICENSE file included as
# part of this distribution.

package LJ::Setting::CommentEmailNotify;
use base 'LJ::Setting';
use strict;
use warnings;

sub should_render {
    my ($class, $u) = @_;

    return $u && !$u->is_community ? 1 : 0;
}

sub selected {
    my ($class, $u) = @_;

    return $u->{opt_gettalkemail} eq "Y" ? 1 : 0;
}

sub label {
    my $class = shift;

    return $class->ml('setting.commentemailnotify.label');
}

sub option {
    my ($class, $u, $errs, $args, %opts) = @_;

    return $class->htmlcontrol($u, $errs, $args, %opts) . " " . $class->htmlcontrol_label($u);
}

sub htmlcontrol_label {
    my ($class, $u) = @_;
    my $key = $class->pkgkey;

    return "<label for='${key}commentemailnotify'>" . $class->ml('setting.commentemailnotify.option') . "</label>";
}

sub htmlcontrol {
    my ($class, $u, $errs, $args, %opts) = @_;
    my $key = $class->pkgkey;

    if ($opts{notif}) {
        my $catid = $opts{notif_catid};
        my $ntypeid = $opts{notif_ntypeid};

        return LJ::html_check({
            class => "SubscribeCheckbox-$catid-$ntypeid",
            selected => 1,
            disabled => 1,
        });
    } else {
        return LJ::html_check({
            name => "${key}commentemailnotify",
            id => "${key}commentemailnotify",
            class => "SubscriptionInboxCheck",
            value => 1,
            selected => $class->selected($u) ? 1 : 0,
        });
    }
}

sub save {
    my ($class, $u, $args) = @_;

    my $val = $class->get_arg($args, "commentemailnotify") ? "Y" : "N";
    $u->update_self( { opt_gettalkemail => $val } );

    return 1;
}

1;
