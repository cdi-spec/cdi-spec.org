---
layout: default
---

Guidelines for contributing to CDI 1.1 via the Expert Group (EG)
================================================================

EG Membership
-------------

We intend to develop CDI 1.1 on an open mailing list, of which all members are consider part of the EG although some discussions may require you to have signed the JSPA in which case you will need to apply via the JCP page. You may just want to have your name listed on the JCP pages also!

* Primary mailing list: <https://lists.jboss.org/mailman/listinfo/cdi-dev>
* JCP page: <http://jcp.org/en/jsr/summary?id=346>
* IRC: <irc://freenode.net/#jsr346>
* Twitter: <https://twitter.com/#!/jsr346>

We will have occasional phone calls as needed, primarily so that we know how we all sound!

Resources
---------

In addition to the mailing lists, we use JIRA to track issues [https://issues.jboss.org/browse/CDI](https://issues.jboss.org/browse/CDI). If you want to register an error in the specification (JIRA calls this a *Bug*), request a clarification (JIRA calls this a *Clarification*) or request a new feature (JIRA calls this a *Feature Request*), please create an issue. 

When you create an issue please set the Affects Version to 1.0 and do not set a Fix Version. The CDI specification lead (Pete Muir) will check the issue, and either request clarification if the report is not clear, or raise it with the EG to discuss whether it should be fixed for 1.1.

The current draft of the specification is available on github at <http://github.com/jboss/cdi> - you are welcome to clone this repository, and create patches and submit pull requests if you wish. It is the duty of the specification lead to ensure that the specification is consistent and well written, so expect some backwards and forwards before your patch is accepted!

Having crafted your changes, please push them to your fork on github, and then create a pull request. This creates an easy forum in which the EG can review your changes.


Guidelines for interacting with the EG
--------------------------------------

We hope the EG can be a friendly and informal place to work, and as such we have laid out a few guidelines which it will help if you follow.

Firstly, consider whether you want to send an email, or add a comment in JIRA. If you wish to discuss the merits of a change or request more explanation of a proposed change, then send an email. If you want to make a technical proposal or propose an API design, add a comment to an issue. There are no hard and fast rules about when to send an email vs add a comment, but remember that comments are there for posterity, and can help people understand why certain design decision was made.

Secondly, try to make every post or comment say something meaningful. Endless "I agree" or "+1" emails aren't that useful and distract from the real discussion about API improvements. Of course, if you strongly disagree with a proposal, please speak up, but in general silence is taken as approval!

Thirdly, please try keep the EG a pleasant place - there is no need for rants, swearing or personal comments - these cannot help the specification in anyway. If you want to make an argument, back it up with concrete statements and examples.

Finally, the EG should be a place where consensus is reached, so in general we won't vote on issues.


Issue Resolution Rules
----------------------

For minor issues where there is obvious fix and no one from the EG has commented, a pull request will be created and once reviewed by the spec lead, merged into master.

For minor issues where there is discussion about how to fix, and for all major issues, a pull requests created when it appears that a consensus has been reached in the EG.  The pull request will not be merged for at least 2 weeks, giving the EG time to review. If issues are raised by the EG then these will be addressed and the 2 week period restarted.

If the EG cannot reach consensus, then a simple majority will decide the outcome (as determined by the spec lead). A similar 2 week period applies.


Community Sponsored Issues
--------------------------

There are a number of issues which have merit (i.e. are addressing a valid problem/use case for CDI) but which have not been identified as a priority by the spec lead. If an EG member wishes to see this issue resolved in the spec, then they can sponsor the issue. Practically this means that the sponsor:

* is responsible for the spec changes (with help/review from spec lead)
* is responsible for TCK tests (help from TCK lead, review from spec lead)
* is not responsible for implementing the feature in the RI
