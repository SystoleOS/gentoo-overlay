# Copyright @ 2019-2023 Oslo University Hospital
# Distributed under the terms of the BSD 3 Clause License

EAPI=7

DESCRIPTION="Bundle package for 3D Slicer"
HOMEPAGE="https://slicer.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="python"

RDEPEND="
	sci-medical/Slicer
	Slicer-Loadable/Annotations[python?]
	Slicer-Loadable/Cameras[python?]
	Slicer-Loadable/Colors[python?]
	Slicer-Loadable/Data[python?]
	Slicer-Loadable/Markups[python?]
	Slicer-Loadable/Models[python?]
	Slicer-Loadable/Plots[python?]
	Slicer-Loadable/Reformat[python?]
	Slicer-Loadable/SceneViews[python?]
	Slicer-Loadable/Segmentations[python?]
	Slicer-Loadable/SlicerWelcome[python?]
	Slicer-Loadable/SubjectHierarchy[python?]
	Slicer-Loadable/Tables[python?]
	Slicer-Loadable/Terminologies[python?]
	Slicer-Loadable/Texts[python?]
	Slicer-Loadable/Transforms[python?]
	Slicer-Loadable/Units[python?]
	Slicer-Loadable/ViewControllers[python?]
	Slicer-Loadable/VolumeRendering[python?]
	Slicer-Loadable/Volumes[python?]
	python? (
		Slicer-Scripted/CropVolumeSequence
		Slicer-Scripted/DICOM
		Slicer-Scripted/DICOMLib
		Slicer-Scripted/DICOMPatcher
		Slicer-Scripted/DICOMPlugins
		Slicer-Scripted/DMRIInstall
		Slicer-Scripted/DataProbe
		Slicer-Scripted/Endoscopy
		Slicer-Scripted/ExtensionWizard
		Slicer-Scripted/ImportItkSnapLabel
		Slicer-Scripted/PerformanceTests
		Slicer-Scripted/SampleData
		Slicer-Scripted/ScreenCapture
		Slicer-Scripted/SegmentEditor
		Slicer-Scripted/SegmentStatistics
		Slicer-Scripted/SelfTests
		Slicer-Scripted/VectorToScalarVolume
		Slicer-Scripted/WebServer
		)
"
