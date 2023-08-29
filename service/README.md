Chart này được dùng để deploy các app khác nhau nó đã được cấu hình đầy đủ các deployment, service, autoscaling, ingress
---
Dưới đây là 1 ví dụ về file values.yaml để deploy debezium connector:
    replicaCount: 1

    image:
      repository: ltrungtrieu/debezium
      pullPolicy: IfNotPresent
      # Overrides the image tag whose default is the chart appVersion.
      tag: nightly
    
    env:
      - name: GROUP_ID
        value: '1'
      - name: CONFIG_STORAGE_TOPIC
        value: "debezium_configs"
      - name: OFFSET_STORAGE_TOPIC
        value: "debezium_offsets"
      - name: STATUS_STORAGE_TOPIC
        value: "debezium_statuses"
      - name: BOOTSTRAP_SERVERS
        value: kafka-broker-0.kafka-broker-headless.kafka.svc.cluster.local:9092,kafka-broker-1.kafka-broker-headless.kafka.svc.cluster.local:9092,kafka-broker-2.kafka-broker-headless.kafka.svc.cluster.local:9092
      - name: "sasl.mechanism"
        value: "PLAIN"

    imagePullSecrets: []
    nameOverride: "debezium"
    fullnameOverride: "debezium"

    serviceAccount:
      # Specifies whether a service account should be created
      create: true
      # Annotations to add to the service account
      annotations: {}
      # The name of the service account to use.
      # If not set and create is true, a name is generated using the fullname template
      name: ""

    podAnnotations:
      custom-pod-name: debezium

    podSecurityContext: {}
      # fsGroup: 2000

    securityContext: {}
      # capabilities:
      #   drop:
      #   - ALL
      # readOnlyRootFilesystem: true
      # runAsNonRoot: true
      # runAsUser: 1000

    service:
      type: ClusterIP
      port: 8083

    ingress:
      enabled: false
      className: ""
      annotations: {}
        # kubernetes.io/ingress.class: nginx
        # kubernetes.io/tls-acme: "true"
      hosts:
        - host: chart-example.local
          paths:
            - path: /
              pathType: ImplementationSpecific
      tls: []
      #  - secretName: chart-example-tls
      #    hosts:
      #      - chart-example.local

    resources: {}
      # We usually recommend not to specify default resources and to leave this as a conscious
      # choice for the user. This also increases chances charts run on environments with little
      # resources, such as Minikube. If you do want to specify resources, uncomment the following
      # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
      # limits:
      #   cpu: 100m
      #   memory: 128Mi
      # requests:
      #   cpu: 100m
      #   memory: 128Mi

    autoscaling:
      enabled: false
      minReplicas: 1
      maxReplicas: 3
      targetCPUUtilizationPercentage: 80
      # targetMemoryUtilizationPercentage: 80

    nodeSelector: {}

    tolerations: []

    affinity: {}

Sau đó có thể sử dụng command để deploy:
---
    helm install <release> charts/app/ -f values.yaml --namespace <namespace> --create-namespace

Và nếu có cấu hình nào thay đổi có thể sử dụng command để cập nhật lại thông tin và restart service:
---
    helm upgrade <release> charts/app/ -f values.yaml --namespace <namespace> --create-namespace
