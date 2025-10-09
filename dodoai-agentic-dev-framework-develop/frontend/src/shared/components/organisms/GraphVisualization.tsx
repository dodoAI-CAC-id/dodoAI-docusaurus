import { useEffect, useRef, useState } from 'react'
import { Network } from 'vis-network'
import { DataSet } from 'vis-data'
import { useQuery } from '@apollo/client'
import { GET_GRAPH_DATA } from '@/features/template-management/infrastructure/graphql/queries'
import { Button } from '@/shared/components/atoms/Button'

interface GraphNode {
  id: string
  label: string
  group: string
  title?: string
}

interface GraphEdge {
  from: string
  to: string
  label?: string
}

export function GraphVisualization() {
  const networkRef = useRef<HTMLDivElement>(null)
  const networkInstance = useRef<Network | null>(null)
  const [selectedNode, setSelectedNode] = useState<string | null>(null)
  
  const { data, loading, error } = useQuery(GET_GRAPH_DATA)

  useEffect(() => {
    if (!data || !networkRef.current) return

    const nodes: GraphNode[] = []
    const edges: GraphEdge[] = []

    data.projects?.forEach((project: any) => {
      nodes.push({
        id: project.id,
        label: project.name,
        group: 'project',
        title: `Project: ${project.name}\n${project.description || ''}`
      })

      project.tasks?.forEach((task: any) => {
        nodes.push({
          id: task.id,
          label: task.name,
          group: 'task',
          title: `Task: ${task.name}\nCategory: ${task.category}`
        })

        edges.push({
          from: project.id,
          to: task.id,
          label: 'contains'
        })

        task.templates?.forEach((template: any) => {
          nodes.push({
            id: template.id,
            label: template.name,
            group: 'template',
            title: `Template: ${template.name}`
          })

          edges.push({
            from: task.id,
            to: template.id,
            label: 'has'
          })
        })
      })
    })

    const options = {
      nodes: {
        shape: 'dot',
        size: 20,
        font: {
          size: 14,
          color: '#333333'
        },
        borderWidth: 2
      },
      edges: {
        width: 2,
        color: { color: '#848484' },
        arrows: {
          to: { enabled: true, scaleFactor: 1 }
        },
        font: {
          size: 12,
          color: '#666666'
        }
      },
      groups: {
        project: {
          color: { background: '#3B82F6', border: '#1E40AF' },
          shape: 'circle'
        },
        task: {
          color: { background: '#10B981', border: '#047857' },
          shape: 'square'
        },
        template: {
          color: { background: '#F59E0B', border: '#D97706' },
          shape: 'diamond'
        }
      },
      physics: {
        enabled: true,
        stabilization: { iterations: 100 }
      },
      interaction: {
        hover: true,
        selectConnectedEdges: false
      }
    }

    if (networkInstance.current) {
      networkInstance.current.destroy()
    }

    const nodesDataSet = new DataSet(nodes)
    const edgesDataSet = new DataSet(edges)
    
    networkInstance.current = new Network(
      networkRef.current,
      { nodes: nodesDataSet, edges: edgesDataSet },
      options
    )

    networkInstance.current.on('selectNode', (event) => {
      if (event.nodes.length > 0) {
        setSelectedNode(event.nodes[0])
      }
    })

    networkInstance.current.on('deselectNode', () => {
      setSelectedNode(null)
    })

    return () => {
      if (networkInstance.current) {
        networkInstance.current.destroy()
        networkInstance.current = null
      }
    }
  }, [data])

  const handleFitToView = () => {
    if (networkInstance.current) {
      networkInstance.current.fit()
    }
  }

  const handleResetZoom = () => {
    if (networkInstance.current) {
      networkInstance.current.moveTo({
        position: { x: 0, y: 0 },
        scale: 1
      })
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-lg text-gray-600">Loading graph data...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-lg text-red-600">Error loading graph data: {error.message}</div>
      </div>
    )
  }

  return (
    <div className="w-full h-full">
      <div className="mb-4 flex gap-2">
        <Button onClick={handleFitToView} variant="secondary" size="sm">
          Fit to View
        </Button>
        <Button onClick={handleResetZoom} variant="secondary" size="sm">
          Reset Zoom
        </Button>
        {selectedNode && (
          <div className="ml-4 px-3 py-1 bg-blue-100 text-blue-800 rounded-md text-sm">
            Selected: {selectedNode}
          </div>
        )}
      </div>
      
      <div className="border border-gray-300 rounded-lg overflow-hidden">
        <div ref={networkRef} className="w-full h-96" />
      </div>
      
      <div className="mt-4 flex gap-4 text-sm text-gray-600">
        <div className="flex items-center gap-2">
          <div className="w-4 h-4 bg-blue-500 rounded-full"></div>
          <span>Projects</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-4 h-4 bg-green-500"></div>
          <span>Tasks</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-4 h-4 bg-yellow-500 transform rotate-45"></div>
          <span>Templates</span>
        </div>
      </div>
    </div>
  )
}
