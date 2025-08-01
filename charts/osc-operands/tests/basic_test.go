package tests

import (
	"context"
	"os"

	"testing"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"

	"k8s.io/apimachinery/pkg/runtime/schema"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/rest"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/dynamic"
)


var _ = Describe("KataConfig CR", func() {
	var dynClient dynamic.Interface
	var kataConfigExists bool

	BeforeEach(func() {
		config, err := rest.InClusterConfig()
		if err != nil {
			config, err = clientcmd.BuildConfigFromFlags("", os.Getenv("KUBECONFIG"))
		}
		Expect(err).NotTo(HaveOccurred())

		dynClient, err = dynamic.NewForConfig(config)
		Expect(err).NotTo(HaveOccurred())
	})

	It("checks if KataConfig CR is installed", func() {
		gvr := schema.GroupVersionResource{
			Group:    "kataconfiguration.openshift.io",
			Version:  "v1",
			Resource: "kataconfigs",
		}

		_, err := dynClient.Resource(gvr).Namespace("").
			Get(context.TODO(), "example-kataconfig", metav1.GetOptions{})

		if err == nil {
			kataConfigExists = true
		}
		Expect(err).NotTo(HaveOccurred(), "KataConfig CR example-kataconfig is missing")
	})

	It("checks if runtime classes are available", func() {
		if !kataConfigExists {
			Skip("Skipping: KataConfig CR is missing")
		}

		gvr := schema.GroupVersionResource{
			Group:    "node.k8s.io",
			Version:  "v1",
			Resource: "runtimeclasses",
		}

		_, err := dynClient.Resource(gvr).Get(context.TODO(), "kata-remote", metav1.GetOptions{})
		Expect(err).NotTo(HaveOccurred(), "kata-remote RuntimeClass is missing")
	})
})

func TestSuite(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "KataConfig Test Suite")
}
