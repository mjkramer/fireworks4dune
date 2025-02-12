#!/usr/bin/env python3

"""
Use this script to set the FireWorks "category" for a particular step in the
production chain. The category is what we pass to e.g. slurm/fw_cpu.slurm.sh
which then passes it to run_rlaunch.sh. The pilot job then only runs FireWorks
with the matching category.

For example, we normally set the (rock) GENIE and edep-sim FireWorks to have the
"cpu_hours" category (see the workflows/fwsub_... scripts), and then we submit
Slurm pilot jobs with that same category so that they can run either GENIE or
edep-sim. But if we decided that we wanted to only run GENIE for now, we can set
a different category for the edep-sim FireWorks:

set_category.py -n MiniRunF6.3_1E19_FHC.edep.rock -c just_rock_edep

And then when we want to actually run edep-sim, we could either submit a Slurm
job under the "just_rock_edep" category, or run set_category.py again to restore
the "cpu_hours" category for the edep-sim FireWorks, in which case they'll get
picked up by any existing/future Slurm jobs under the "cpu_hours" category.

(Of course, we could have also modified the category of the GENIE FireWorks, and
then submitted Slurm jobs under that new category.)

Something similar could be accomplished by running "lpad pause_fws -n
MiniRunF6.3_1E19_FHC.edep.rock", but this can be quite slow when there are a lot
of FireWorks.
"""

import argparse

from fireworks import LaunchPad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-n', '--name', required=True,
                    help='"Name" of the FireWorks to update (e.g. MiniRunF6.3_1E19_FHC.edep.rock)')
    ap.add_argument('-c', '--category', required=True,
                    help='Category to set (e.g. cpu_hours)')
    args = ap.parse_args()

    lpad = LaunchPad.auto_load()
    db = lpad.connection[lpad.name]
    fws = db['fireworks']

    query = {'name': args.name}
    update = {'$set': {'spec._category': args.category}}
    fws.update_many(query, update)


if __name__ == '__main__':
    main()
