# General philosophies #

In general, the data we are returning from wave-client uses property lists to describe list of properties, and hashtables for data where the keys are not from a predefined set.  So, structures such as a description of a blip is a property list, but the set of all blips (keyed by blip-id) is a hashtable.  We do not use assoc lists.

# Nomenclature #

There's three terms for authorship in general:
  * _creator_: Someone who creates the wave.
  * _author_: Applies to a blip.  The users responsible for modifying that blip.
  * _participant_: Those who have contributed in some way to the wave.  This should just be the union of all the authors of the historical blips in a wave.

# `wave-list` spec #

The `wave-list` returns a list of wave summaries.

## Wave summary ##

Each wave summary is a plist with the following properties:
  * `:id` An id string that uniquely identifies the root wavelet.
  * `:unread` How many blips are unread in this wave.
  * `:digest` The summary text of the wave.
  * `:creator` The address of the wave's original creator.

# `wave-get-wave` spec #

The `wave-get-wave` call returns a list of wavelets.  A wavelet is a part of a wave that can have a different participant lists.

## Wavelet ##

A wavelet is a plist with the following properties:
  * `:participants` List of participant addresses.
  * `:creator` The address of the author
  * `:wavelet-name` A cons of two strings, wave-id and wavelet-id.
  * `:creation-time` _Not yet defined_.
  * `:blips` A hashtable of all the blips, keyed by `intern`'d blip-id, with a value described below.

## Blip ##

A blip is a plist with the following properties:
  * `:blip-id` The id, an interned symbol
  * `:authors` The users who wrote this blip.
  * `:modified-time` _Not yet defined_.
  * `:modified-version` The wavelet version at which this blip was most recently modified.
  * `:content` The content, described as a document initialization.  See below for a full description.

## Document initialization ##

A document initialization is a list of document operation components, which may be:
  * _a string_ In which case, this is plain text.
  * _a list starting with_ `@boundary` See the annotation boundary section below.
  * _a list of XML element name and attributes_ Opens an XML element.
  * `end` Ends a closest previous element.

## Annotation boundary ##

This is a list.

Each entry in the list starts out with `change` or `end` symbols.  It then describes a list of changes or ends, each with:

  * `:key`  The boundary key.
  * `:oldvalue` The previous value.
  * `:newvalue` The new value.

A boundary, with a certain key, will start with a `change` boundary, then end some time later with an `end` boundary (note: not an `end` in the document initialization).